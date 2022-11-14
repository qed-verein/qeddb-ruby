# Die Klasse "Registration" verwaltet eine einzelne Anmeldung einer Person zu einer Veranstaltung.

class Registration < ApplicationRecord
	# Versionskontrolle
	has_paper_trail

	# Verweis auf die Veranstaltung und die Person
	belongs_to :event
	belongs_to :person

	# Der Anmeldestatus des Teilnehmers
	#  pending:   Die Person hat sich gerade erst angemeldet
	#  confirmed: Die Person hat eine Platzzusage zur Veranstaltung
	#  rejected:  Die Person wurde abgelehnt
	#  cancelled: Die Person hat von sich aus abgesagt
	enum status: {pending: 1, confirmed: 2, rejected: 3, cancelled: 4}

	# Validierungen
	validates :person, :event, presence: true
	validates :person, uniqueness: {scope: :event, message:
		Proc.new {|reg, _| sprintf("%s ist bereits zur Veranstaltung angemeldet", reg.person.full_name)}}
	validates :status, inclusion: {in: Registration.statuses.keys}
	validates :organizer, inclusion: {in: [true, false]}

	validates :money_amount, numericality: {greater_than_or_equal_to: 0}, allow_nil: true
	validates :nights_stay, numericality: {greater_than_or_equal_to: 0, only_integer: true}

	with_options if: Proc.new {|reg| reg.payment_complete} do
		validates :member_discount, inclusion: {in: [true, false]}
		validates :money_transfer_date, presence: true
		validates :money_amount, presence: true
		validates :nights_stay, presence: true
	end

	validate :time_ordering
	validates :station_arrival, :station_departure, :railway_discount, length: {maximum: 200}
	validates :meal_preference, :talks, :comment, length: {maximum: 1000}

	# Teilnehmer muss Teilnahmebedingungen akzepteren
	attr_accessor :terms_of_service
	validates :terms_of_service, acceptance: {message: "Teilnahmebedingungen müssen akzeptiert werden"}

	validate :max_participants_not_exceeded

	# Standardwerte für die Anmeldung (z.B. für Essenswünsche)
	def set_defaults
		self.status ||= :pending
		self.organizer = false if organizer.nil?

		self.payment_complete = false if payment_complete.nil?
		if member_discount.nil? && !person.nil? && !event.nil?
			self.member_discount = person.member_at_time?(event.start)
		end

		# Übernehme Standardeinstellungen zu Anreise ect. aus dem Veranstaltungsprofil
		if event.nil?
			self.money_amount = 0 if money_amount.nil?
		else
			max_days = ((event.end.middle_of_day - event.start.middle_of_day) / 1.day).round
			self.nights_stay = max_days if nights_stay.blank?
			self.arrival = event.start if arrival.blank?
			self.departure = event.end if departure.blank?
			self.money_amount = event.cost if money_amount.nil?
		end

		# Übernehme Standardeinstellungen zu Bahnhöfen, Essenswünschen etc. aus den Personendaten
		unless person.nil?
			self.station_arrival = person.railway_station if station_arrival.blank?
			self.station_departure = person.railway_station if station_departure.blank?
			self.railway_discount = person.railway_discount if railway_discount.blank?
			self.meal_preference = person.meal_preference if meal_preference.blank?
		end
	end

	def self.status_active?(status)
		['pending', 'confirmed'].include?(status)
	end

	def active?
		Registration.status_active?(status)
	end

	def object_name
		event.title + " » " + person.full_name
	end

	private

	# Prüft ob die zeitliche Reihenfolge von Anreise und Abreise korrekt ist.
	def time_ordering
		if arrival.present? && departure.present? && arrival >= departure
			errors.add :arrival, " muss früher als #{Registration.human_attribute_name :departure} sein"
		end
	end

	# Prüft ob noch Plätze für Anmeldung verfügbar sind.
	def max_participants_not_exceeded
		# Zähle wie viele Plätze vorher benötigt wurden
		count = event.participants.count
		# Bei einer Zusage brauchen wir einen Platz mehr
		count += 1 if active? && !Registration.status_active?(status_was)
		# Bei einer Absage brauchen wir einen Platz weniger
		count -= 1 if !active? && Registration.status_active?(status_was)

		unless count <= event.max_participants
			errors.add :base, "Die Anzahl der angemeldeten Teilnehmer darf das Teilnehmerlimit nicht übersteigen"
		end
	end
end
