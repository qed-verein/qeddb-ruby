# Die Klasse "Event" verwaltet eine Veranstaltung, zu der sich Personen anmelden können.
require 'general_helpers.rb'

class Event < ApplicationRecord
	include GeneralHelpers
	# Versionskontrolle
	has_paper_trail

	# Standmäßig Veranstaltung absteigend nach Datum ordnen
	default_scope {order(start: :desc)}

	# Alle Anmeldungen für dieser Veranstaltung
	has_many :registrations, -> { includes(:person).order('people.last_name') }, dependent: :destroy,
		inverse_of: :event
	# Die zugehörigen Personen dieser Anmeldungen
	has_many :people, through: :registrations

	# Alle Teilnehmer dieser Veranstaltung (außer Absagen)
	has_many :participants, -> {where(registrations: {status: [:pending, :confirmed]})},
		source: :person, through: :registrations
	# Alle Organisatoren dieser Veranstaltung
	has_many :organizers, -> {where(registrations: {organizer: true})},
		source: :person, through: :registrations

	# Rechtegruppen für Organisatoren und Teilnehmer
	has_one :organizer_group, -> {where(program: :organizers)}, class_name: 'Group', dependent: :destroy
	has_one :participant_group, -> {where(program: :participants)}, class_name: 'Group', dependent: :destroy

	#~ has_one :organizer_mailing_list, :through :organizer_group, class_name: 'Mailinglist'
	#~ has_one :participant_mailing_list, :through :participant_group,  class_name: 'Mailinglist'

	# Verweis auf die Unterkunft
	belongs_to :hostel, optional: true

	validates :title, :start, :end, :max_participants, presence: true
	validates :title, length: {maximum: 100}
	validates :homepage, length: {maximum: 200}
	validate :time_ordering
	validates :cost, numericality: {greater_than_or_equal_to: 0}
	validates :max_participants, numericality: {only_integer: true, greater_than_or_equal_to: 0}
	validates :comment, length: {maximum: 1000}
	validate :max_participants_not_exceeded

	after_create :create_groups
	after_save :update_groups

	# Zu jeder Veranstaltungen existiert für die Organistatoren sowie die Teilnehmer je eine Gruppe
	# Diese können anschließend in Rechtemanagement oder in den Mailverteilern weiterverwendet werden. (siehe hierzu model/group.rb)
	def organizer_group_data(title)
		{
			title: sprintf("Organisatoren von „%s“", title),
			description: sprintf("Alle Organisatoren der Veranstaltung „%s“", title),
			event: self, mode: :automatic, program: :organizers}
	end

	def participant_group_data(title)
		{
			title: sprintf("Teilnehmer von „%s“", title),
			description: sprintf("Alle Teilnehmer der Veranstaltung „%s“", title),
			event: self, mode: :automatic, program: :participants}
	end

	def create_groups
		Group.create!(organizer_group_data(title))
		Group.create!(participant_group_data(title))
	end

	def update_groups
		organizer_group.update(organizer_group_data(title))
		participant_group.update(participant_group_data(title))
	end

	# Sind Anmeldungen derzeit möglich?
	def can_create_registration?
		!full? && !deadline_missed?
	end

	# Können Anmeldungen von Teilnehmern geändert werden?
	def can_edit_registration?
		!deadline_missed? # TODO: Separate Deadline zum Bearbeiten der Anmeldedaten?
	end

	# Prüft ob die Veranstaltung schon ausgebucht ist
	def full?
		# TODO evenutell nur Teilehnmer mit Status = confirmed?
		max_participants.nil? || participants.count >= max_participants
	end

	# Ist der Anmeldeschluss schon vorbei
	def deadline_missed?
		return !deadline.nil? && Date.today > deadline
	end

	# Ist die Veranstaltung derzeit noch von Organisatoren bearbeitbar
	def still_organizable?
		Event.still_organizable.where(id: id).exists?
	end

	# Ist die Veranstaltung derzeit noch von Organisatoren bearbeitbar
	scope :still_organizable, -> {
		where("? <= events.end", Rails.configuration.lock_event_after_end.ago.strftime("%F %X"))}

	# Die Emailadresse der Teilnehmer
	def participant_email_address
		return nil if participant_group.nil?
		mailinglist = Mailinglist.find_by(receiver_group_id: participant_group.id)
		return mailinglist && mailinglist.title + "@" + Rails.configuration.mailinglist_domain
	end

	# Die Emailadresse der Organisatoren
	def organizer_email_address
		return nil if organizer_group.nil?
		mailinglist = Mailinglist.find_by(receiver_group_id: organizer_group.id)
		return mailinglist && mailinglist.title + "@" + Rails.configuration.mailinglist_domain
	end

	def object_name
		title
	end

	def reference_line
		asciify title
	end

	private

	# Überprüft ob die angegeben Zeiten für Anfang und Ende in der korrekten Reihenfolge sind.
	def time_ordering
		unless start.present? && self.end.present? && start <= self.end
			errors.add(:start, " muss früher als #{Event.human_attribute_name :end} sein")
		end
	end

	# Stellt sicher, dass das Teilnehmerlimit nicht kleiner als Teilnehmeranzahl wird
	def max_participants_not_exceeded
		# TODO evenutell mit confirmed_participants?
		if max_participants && participants.count > max_participants
			errors.add(:max_participants, " darf nicht kleiner als die Anzahl der angemeldeten Teilnehmer sein")
		end
	end
end
