# Die Klasse "Group" dient zur Verwaltung von Gruppen.
# Eine Gruppe besteht im Wesentlichen aus einer Liste von Personen.
#
#
# Für editierbare Gruppen muss eine Liste von Zugehörigkeiten (Affiliations)
# erstellt werden. Als Einträge dieser Liste können Personen sowie weitere Untergruppen
# angegeben werden. Jeder Eintrag enthält zudem einen Zeitraum, in welcher dieser gültig ist.
#
# Möchte man alle Untergruppen oder Mitglieder oder einer Gruppe wissen,
# so stehen hierfür die SQL-Views recursive_subgroups, recursive_members zur Verfügung.

class Group < ApplicationRecord
  # Versionskontrolle
  has_paper_trail

  # Welcher Typ von Gruppe liegt vor?
  # Momentan gibt es einige verschiedene Gruppentypen:
  #   0) manual = Manuell verwaltete Liste 
  #   1) board_members = Liste der Vorstände
  #   2) treasurers = Liste der Kassenwärte
  #   3) admins = Liste der Webmaster
  #   4) members = Alle Mitglieder (nicht editierbar)
  #   5) externals = Alle Externen (nicht editierbar)
  #   6) newsletter = Alle die den Newsletter haben wollen (nicht editierbar)
  #   7) organizers = Organisatoren eines Veranstaltung (nicht editierbar)
  #   8) participants = Teilnehmer einer Veranstaltung (nicht editierbar)
  #   9) auditors = Kassenprüfer:innen

  enum kind: { manual: 0, board_members: 1, treasurers: 2, admins: 3,
                  members: 4, externals: 5, newsletter: 6,
                  organizers: 7, participants: 8, auditors: 9 }

  # Validierungen
  validates :title, length: { maximum: 50 }, presence: true, uniqueness: true
  validates :description, length: { maximum: 1000 }
  validates :kind, inclusion: { in: kinds.keys }, allow_nil: true

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
    not %w[members externals newsletter participants organizers].include?(kind)
  end

  # Kann diese Gruppe von Admins gelöscht werden?
  def destroyable?
    kind == :manual
  end

  # Ist eine Person in dieser Gruppe enthalten?
  def member?(person)
    members.exists?(id: person.id)
  end

  # Das Formular zum Bearbeiten einer Gruppe schickt auch eine Liste
  # von einzutragenden Personen und weiteren Gruppen mit
  has_many :member_affiliations, -> { where groupable_type: 'Person' },
           class_name: 'Affiliation', inverse_of: :group
  has_many :group_affiliations, -> { where groupable_type: 'Group' },
           class_name: 'Affiliation', inverse_of: :group
  accepts_nested_attributes_for :member_affiliations,
                                allow_destroy: true,
                                reject_if: proc { |attr| reject_blank_entries? attr, :groupable_id }
  accepts_nested_attributes_for :group_affiliations,
                                allow_destroy: true,
                                reject_if: proc { |attr| reject_blank_entries? attr, :groupable_id }
  after_initialize :set_defaults

  # Standardwerte für Gruppen
  def set_defaults
    self.kind ||= :manual
  end

  def object_name
    title
  end

  default_scope { order(:title) }
end
