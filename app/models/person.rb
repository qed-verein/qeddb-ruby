# Diese Klasse "Person" verwaltet alle Personen in der Mitgliederdatenbank.
# Dazu zählen nicht nur Vereinsmitglieder, sondern auch auch Externe.
# Daneben ist die Klasse "Person" auch für das Loginmanagement zuständig.
# Dies tun wir jedoch nicht selber, sondern benutzen hierfür das Paket "Sorcery".

class Person < ApplicationRecord
	include GeneralHelpers
	# Alle Änderungen an Person werden gespeichert. Hierzu benutzen wir das Paket "PaperTrail".
	has_paper_trail skip: [:crypted_password, :salt, :reset_password_token]

	# Diese Klasse ist für das Loginmanagement zuständig. Hierzu benutzen wir das Paket "Sorcery".
	authenticates_with_sorcery!

	# Alle Adressen, Kontakte und Zahlungen, welcher zu einer Person gehören
	has_many :addresses, as: :addressable, inverse_of: :addressable, dependent: :destroy
	has_many :contacts, dependent: :destroy
	has_many :payments, dependent: :destroy
	has_one :sepa_mandate, dependent: :destroy

	# Liste alle Anmeldungen dieser Person auf (einschließlich Absagen, Warteliste etc)
	has_many :registrations, -> { includes('event').order('events.start DESC') }, dependent: :destroy,
		inverse_of: :person
	# Liste die zugehörigen Veranstaltungen aller Anmeldungen auf
	has_many :events, through: :registrations

	# Diese Veranstaltungen werden von der Person organisiert
	has_many :organized_events, -> () {where(registrations: {organizer: true})},
		source: :event, through: :registrations, inverse_of: :organizers
	# An dieser Veranstaltungen hat die Person teilgenommen oder nimmt voraussichtlich teil
	has_many :participated_events, -> () {where(registrations: {status: [:pending, :confirmed]})},
		source: :event, through: :registrations, inverse_of: :participants

	# In diese Gruppen wird die Person explizit eingetragen (siehe Group)
	has_many :affiliations, as: :groupable, inverse_of: :groupable, dependent: :destroy

	# Alle Gruppen, in welche diese Person eingetragen ist (auch indirekt)
	def groups
		Group.joins("INNER JOIN recursive_members AS r ON r.group_id = groups.id").where('r.person_id' => id)
	end

	# Daten zu Adressen, Kontakte und Zahlungen werden ebenfalls mit Person gespeichert
	accepts_nested_attributes_for :addresses, allow_destroy: true, reject_if: proc {|a| reject_blank_entries a}
	accepts_nested_attributes_for :contacts, allow_destroy: true, reject_if: proc {|a| reject_blank_entries a}
	accepts_nested_attributes_for :payments, allow_destroy: true, reject_if: proc {|a| reject_blank_entries a}
	accepts_nested_attributes_for :sepa_mandate, allow_destroy: true, reject_if: proc {|a| reject_blank_entries a}

	enum gender: {male: 1, female: 2, other: 3}

	# Validierungen
	validates :first_name, :last_name, presence: true, length: {maximum: 50}
	validates :account_name, :email_address, presence: true, if: :active
	validates_uniqueness_of :account_name, allow_blank: true

	validates :password, length: {minimum: 6}, if: -> {new_record? || changes[:crypted_password]}, allow_blank: true
	validates :password, confirmation: true, if: -> {new_record? || changes[:crypted_password]}
	validates :password_confirmation, presence: true, if: -> {new_record? || changes[:crypted_password]}, allow_blank: true

	validates :gender, inclusion: {in: genders.keys}, allow_blank: true
	validates :email_address, :railway_station, :railway_discount, :meal_preference, length: {maximum: 200}
	validates :comment, length: {maximum: 1000}
	validate :time_ordering

	# Validiere Eintritt vor Austritt, falls eine der Werte angegeben
	def time_ordering
		unless joined.blank? || quitted.blank? || joined <= quitted
			errors.add :joined, " muss früher als #{Person.human_attribute_name :quitted} sein"
		end
	end

	# Berechne das Ende des bezahlten Zeitraums
	def paid_until_function
		now = Time.now
		maximal_gap = 1.week # Vermeidet Lücken vom 31.12 -> 1.1

		# TODO Fördermitgliedschaft
		intervals = payments.where(payment_type: [:regular_member, :free_member, :sponsor_and_member]).pluck(:start, :end)
		times = intervals.map{|s, e|
			[[s - maximal_gap, 1], [e, -1]]}.flatten(1).sort

		# Die Mitgliedschaft ist bis zum Ende des Beitrittsjahres kostenlos
		if intervals.empty?
			return joined ? joined.end_of_year : nil
		end

		# Suche eine lückenlose Überlappung von bezahlten Intervallen
		# TODO Was tun, wenn Lücken in bezahlten Zeiträumen sind
		sum = 0
		pu = nil
		times.each {|time, add|
			sum += add
			if sum == 0
				pu = time
				return pu if time >= now
			end
		}
		return pu
	end

	# Berechnet, bis wann der Benutzer noch ein Mitglied ist
	def member_until_function
		[paid_until && (paid_until + Rails.configuration.max_deferred_payment), quitted].compact.min
	end

	# Berechnet, bis wann der Benutzer gezahlt hat.
	def compute_membership_status
		self.paid_until = paid_until_function
		self.member_until = member_until_function
		true
	end

	# Nummeriert die Adress- und Kontaktangaben zum Eintragen in die Datenbank durch
	def give_priority_numbers
		addresses.each_with_index {|address, index| address.priority = 1 + index}
		contacts.each_with_index {|contact, index| contact.priority = 1 + index}
	end


	def set_salt
		salt = account_name
	end

	# Hack weil Gallery usw. bislang nur den Benutzernamen zum Salzen benutzen
	def encrypt_password
        config = sorcery_config
        send(:"#{config.salt_attribute_name}=", account_name) unless config.salt_attribute_name.nil?
        send(:"#{config.crypted_password_attribute_name}=", self.class.encrypt(send(config.password_attribute_name), account_name))
	end

	# Berechne das Zahlungsende beim Speichern einer Person automatisch
	before_save :compute_membership_status
	before_save :give_priority_numbers

	# Dies ist ein Standardscope und sorgt dafür, dass Personen nach Nachname sortiert sind
	default_scope {order(:last_name)}

	# ********************
	# * Mitgliederstatus *
	# ********************

	def member?
		member_at_time?(Time.now)
	end

	def member_at_time?(time)
		!joined.nil? && joined <= time &&
		!member_until.nil? && member_until > time
	end

	# Leute mit Attrbiut active=true können sich einloggen (-> siehe Sorcery)
	def active_for_authentication?
		active
	end

	# Ist die Person ein Administrator?
	def admin?
		@is_admin = Group.find_by(program: :admins).has_member?(self) if @is_admin.nil?
		@is_admin
	end

	# Ist die Person ein Kassenwart?
	def treasurer?
		@is_treasurer = Group.find_by(program: :treasurer).has_member?(self) if @is_treasurer.nil?
		@is_treasurer
	end

	# Ist die Person im Vorstand (inkl. Kassenwart)?
	def chairman?
		@is_chairman = Group.find_by(program: :chairman).has_member?(self) || treasurer? if @is_chairman.nil?
		@is_chairman
	end

	# Ist die Person ein Organisator der Veranstaltung?
	def organizer?(event)
		organized_events.exists?(event.id)
	end

	# Ist die Person ein Organisator für eine andere Person auf einer
	# derzeit aktiven Veranstaltung
	def organizer_of_person_now?(person)
		!(organized_events.still_organizable.ids & person.events.ids).empty?
	end

	# Ist die Person ein momentan tätiger Organistator für eine aktive Veranstaltung
	def organizing_now?
		organized_events.still_organizable.exists?
	end

	# Hat sich diese Person zu dieser Veranstaltung angemeldet
	def registered?(event)
		events.exists?(event.id)
	end

	# Nimmt diese Person tatsächlich an der Veranstaltung teil
	def participant?(event)
		participated_events.exists?(event.id)
	end

	# ***************************************************

	# Liefert den vollen Namen einer Person zurück
	def full_name
		first_name + " " + last_name
	end

	def reference_line
		asciify full_name
	end

	# Liefert die Hauptaddresse mit der höchsten Priorität
	def main_address
		return addresses.sort_by{|a| a.priority}.first
	end

	# Liefert die Handynummer mit der höchsten Priorität
	def mobile_number
		contact = contacts.sort_by{|c| c.priority}.select{|c| /mobil|handy/i.match(c.protocol)}.first
		return nil if contact.nil?
		contact.identifier
	end

	# Standardwerte setzen
	after_initialize :set_defaults

	def set_defaults
		self.active = true if active.nil?
		self.meal_preference = "" if self.meal_preference.nil?
		self.comment = "" if self.comment.nil?
		self.newsletter = true if newsletter.nil?
		self.photos_allowed = true if photos_allowed.nil?
		self.publish = true if publish.nil?
		self.publish_birthday = true if publish_birthday.nil?
		self.publish_email = true if publish_email.nil?
		self.publish_address = true if publish_address.nil?
	end

	def object_name
		full_name
	end
end
