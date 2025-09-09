# Die Klasse "Event" verwaltet eine Veranstaltung, zu der sich Personen anmelden können.
require 'general_helpers'

class Event < ApplicationRecord
  include GeneralHelpers

  # Versionskontrolle
  has_paper_trail

  include EventsHelper

  # Standmäßig Veranstaltung absteigend nach Datum ordnen
  default_scope { order(start: :desc) }

  # Alle Anmeldungen für dieser Veranstaltung
  has_many :registrations, -> { includes(:person).order('people.last_name') }, dependent: :destroy,
                                                                               inverse_of: :event
  # Die zugehörigen Personen dieser Anmeldungen
  has_many :people, through: :registrations

  # Alle Teilnehmer dieser Veranstaltung (außer Absagen)
  has_many :participants, -> { where(registrations: { status: %i[pending confirmed] }) },
           source: :person, through: :registrations
  # Alle Organisatoren dieser Veranstaltung
  has_many :organizers, -> { where(registrations: { organizer: true }) },
           source: :person, through: :registrations

  has_many :event_payments, dependent: :destroy

  # Rechtegruppen für Organisatoren und Teilnehmer
  has_one :organizer_group, -> { where(program: :organizers) }, class_name: 'Group', dependent: :destroy
  has_one :participant_group, -> { where(program: :participants) }, class_name: 'Group', dependent: :destroy

  # ~ has_one :organizer_mailing_list, :through :organizer_group, class_name: 'Mailinglist'
  # ~ has_one :participant_mailing_list, :through :participant_group,  class_name: 'Mailinglist'

  accepts_nested_attributes_for :event_payments, allow_destroy: true, reject_if: proc { |a| reject_blank_entries a }

  # Verweis auf die Unterkunft
  belongs_to :hostel, optional: true

  validates :title, :start, :end, :max_participants, presence: true
  validates :title, length: { maximum: 100 }
  validates :homepage, length: { maximum: 200 }
  validate :time_ordering
  validates :cost, numericality: { greater_than_or_equal_to: 0 }
  validates :max_participants, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :comment, length: { maximum: 1000 }
  validates :reference_line, length: { maximum: 25 }
  validates :reference_line,
            format: { with: /\A[a-zA-Z0-9 -]+\z/, message: I18n.t('validations.event.reference_line.charset') }
  validate :max_participants_not_exceeded

  after_initialize :set_defaults
  after_create :create_groups, :create_mailinglists
  after_save :update_groups

  def set_defaults
    self.reference_line = create_reference_line if reference_line.blank?
  end

  # Zu jeder Veranstaltungen existiert für die Organistatoren sowie die Teilnehmer je eine Gruppe
  # Diese können anschließend in Rechtemanagement oder in den Mailverteilern weiterverwendet werden. (siehe hierzu model/group.rb)
  def organizer_group_data(title)
    {
      title: format('Organisatoren von „%s“', title),
      description: format('Alle Organisatoren der Veranstaltung „%s“', title),
      event: self, mode: :automatic, program: :organizers
    }
  end

  def participant_group_data(title)
    {
      title: format('Teilnehmer von „%s“', title),
      description: format('Alle Teilnehmer der Veranstaltung „%s“', title),
      event: self, mode: :automatic, program: :participants
    }
  end

  def create_groups
    Group.create!(organizer_group_data(title))
    Group.create!(participant_group_data(title))
  end

  def organizer_mailinglist_data(email)
    {
      title: email,
      description: format('Mailingliste für Organisatoren der Veranstaltung „%s“', title),
      receiver_group: organizer_group,
      can_unsubscribe: false
    }
  end

  def participant_mailinglist_data(email)
    {
      title: format('%s-teilnehmer', email),
      description: format('Mailingliste für Teilnehmer der Veranstaltung „%s“', title),
      sender_group: participant_group,
      receiver_group: participant_group,
      moderator_group: organizer_group,
      can_unsubscribe: false
    }
  end

  def create_mailinglists
    return if reference_line.blank?

    email = reference_line.gsub(/ /, '').downcase
    Mailinglist.create!(organizer_mailinglist_data(email))
    Mailinglist.create!(participant_mailinglist_data(email))
  end

  # Können Anmeldungen von Teilnehmern geändert werden?
  def can_edit_registration?
    # Teilnehmer dürfen ihre eigenen Daten bis Veranstaltungsende ändern
    !ended?
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

  def ended?
    !self.end.nil? && Date.current > self.end
  end

  # Prüft ob die Veranstaltung schon ausgebucht ist
  def full?
    # TODO: evenutell nur Teilehnmer mit Status = confirmed?
    max_participants.nil? || participants.count >= max_participants
  end

  # Ist der Anmeldeschluss schon vorbei
  def deadline_missed?
    !deadline.nil? && Date.current > deadline
  end

  # Ist die Veranstaltung derzeit noch von Organisatoren bearbeitbar
  def still_organizable?
    Event.still_organizable.exists?(id: id)
  end

  # Ist die Veranstaltung derzeit noch von Organisatoren bearbeitbar
  scope :still_organizable, lambda {
    where('? <= events.end', Rails.configuration.lock_event_after_end.ago.strftime('%F %X'))
  }

  # Die Emailadresse der Teilnehmer
  def participant_email_address
    return nil if participant_group.nil?

    mailinglist = Mailinglist.find_by(receiver_group_id: participant_group.id)
    mailinglist && "#{mailinglist.title}@#{Rails.configuration.mailinglist_domain}"
  end

  # Die Emailadresse der Organisatoren
  def organizer_email_address
    return nil if organizer_group.nil?

    mailinglist = Mailinglist.find_by(receiver_group_id: organizer_group.id)
    mailinglist && "#{mailinglist.title}@#{Rails.configuration.mailinglist_domain}"
  end

  def object_name
    title
  end

  def create_reference_line
    return nil if title.nil?

    ascii_title = asciify title
    ascii_title.gsub(/20\d{2}/) { |match| match.delete_prefix('20') }
  end

  private

  # Überprüft ob die angegeben Zeiten für Anfang und Ende in der korrekten Reihenfolge sind.
  def time_ordering
    return if start.present? && self.end.present? && start <= self.end

    errors.add(:start, " muss früher als #{Event.human_attribute_name :end} sein")
  end

  # Stellt sicher, dass das Teilnehmerlimit nicht kleiner als Teilnehmeranzahl wird
  def max_participants_not_exceeded
    # TODO: evenutell mit confirmed_participants?
    return unless max_participants && participants.count > max_participants

    errors.add(:max_participants, ' darf nicht kleiner als die Anzahl der angemeldeten Teilnehmer sein')
  end
end
