# frozen_string_literal: true

# Die Klasse "Group" dient zur Verwaltung von Gruppen.
# Eine Gruppe besteht im Wesentlichen aus einer Liste von Personen.
#
# Grundsätzlich gibt es drei Arten von Gruppen (mode):
#   automatic: Diese Gruppen werden von Mitgliederdatenbank selber verwaltet
#      und können weder verändert noch gelöscht werden (z.B. Mitglieder)
#   editable: Dieser Gruppen werden ebenfalls von der Mitgliederdatenbank benötigt,
#      jedoch können diese von Administrationen abgeändert werden (z.B. Vorstand)
#   userdefined: Diese Gruppen werden von Admins selber verwaltet (für Projekte z.B.)
#
# Für nichtautomatische Gruppen muss eine Liste von Zugehörigkeiten (Affiliations)
# erstellt werden. Als Einträge dieser Liste können Personen sowie weitere Untergruppen
# angegeben werden. Jeder Eintrag enthält zudem einen Zeitraum, in welcher dieser gültig ist.
#
# Möchte man alle Untergruppen oder Mitglieder oder einer Gruppe wissen,
# so stehen hierfür die SQL-Views recursive_subgroups, recursive_members zur Verfügung.

class Group < ApplicationRecord
  # Versionskontrolle
  has_paper_trail

  # Ist die Gruppe automatisch, bearbeitbar oder benutzerdefiniert? (siehe oben)
  enum mode: { automatic: 1, editable: 2, userdefined: 3 }

  # Welcher Typ von automatischer Gruppe liegt vor?
  # Momentan gibt es acht verschiedene Programme:
  #   1) chairman = Liste der Vorstände
  #   2) treasurer = Liste der Kassenwärte
  #   3) admins = Liste der Webmaster
  #   4) members = Alle Mitglieder
  #   5) externals = Alle Externen
  #   6) newsletter = Alle die Newsletter haben wollen
  #   7) organizers = Organisatoren eines Veranstaltung
  #   8) participants = Teilnehmer einer Veranstaltung
  #   9) auditors = Kassenprüfer:innen

  enum program: { chairman: 1, treasurer: 2, admins: 3,
                  members: 4, externals: 5, newsletter: 6,
                  organizers: 7, participants: 8, auditors: 9 }

  # Validierungen
  validates :title, length: { maximum: 50 }, presence: true, uniqueness: true
  validates :description, length: { maximum: 1000 }
  validates :mode, inclusion: { in: modes.keys }
  validates :program, inclusion: { in: programs.keys }, allow_nil: true

  # Verweis zur Veranstaltung (falls die Gruppe veranstaltungsspezifisch ist)
  belongs_to :event, optional: true

  # Alle eingetragene Gruppenmitgliedschaften
  #  (einschließlich der vergangenen und zukünftigen, noch ohne Rekursion)
  has_many :timeless_entries, class_name: 'Affiliation', dependent: :destroy

  # Alle Mitglieder einer Gruppe (auch mehrfach verschachelt)
  def members
    Person.joins('INNER JOIN recursive_members AS r ON r.person_id = people.id').where('r.group_id' => id)
  end

  # Alle Untergruppen, welche dieser Gruppe hinzugefügt wurden (auch mehrfach verschachelt)
  def subgroups
    Group.joins('INNER JOIN recursive_subgroups AS r ON r.descendant_id = groups.id').where('r.group_id' => id)
  end

  # Alle Obergruppen, zu welcher diese Gruppe hinzugefügt wurde (auch mehrfach verschachelt)
  def supergroups
    Group.joins('INNER JOIN recursive_subgroups AS r ON r.group_id = groups.id').where('r.descendant_id' => id)
  end

  # Kann diese Gruppe von Admins bearbeitet werden?
  def editable?
    %w[userdefined editable].include?(mode)
  end

  # Kann diese Gruppe von Admins gelöscht werden?
  def destroyable?
    mode == 'userdefined'
  end

  # Ist eine Person in dieser Gruppe enthalten?
  def has_member?(person)
    members.exists?(id: person.id)
  end

  # Das Formular zum Bearbeiten einer Gruppe schickt auch eine Liste
  # von einzutragenden Personen und weiteren Gruppen mit
  has_many :member_affiliations, -> { where groupable_type: 'Person' },
           class_name: 'Affiliation', inverse_of: :group
  has_many :group_affiliations, -> { where groupable_type: 'Group' },
           class_name: 'Affiliation', inverse_of: :group
  accepts_nested_attributes_for :member_affiliations, allow_destroy: true,
                                                      reject_if: proc { |attr|
                                                        reject_blank_entries attr, :groupable_id
                                                      }
  accepts_nested_attributes_for :group_affiliations, allow_destroy: true,
                                                     reject_if: proc { |attr|
                                                       reject_blank_entries attr, :groupable_id
                                                     }
  after_initialize :set_defaults

  # Standardwerte für Gruppen
  def set_defaults
    self.mode ||= :userdefined
  end

  def object_name
    title
  end

  default_scope { order('title ASC') }
end
