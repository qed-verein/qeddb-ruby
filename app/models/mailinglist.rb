# Die Klasse "Mailinglist" verwaltet einen Emailverteiler.
# Für jeden Emailverteiler kann jeweils eine Gruppe für die Sender, Empfänger und Moderatoren angegeben werden.
# Darüberhinaus können auch manuelle Emailadressen hinzugefügt werden.
# (z.B. für Leute die nicht in der Datenbank stehen)

class Mailinglist < ApplicationRecord
  # Versionskontrolle
  has_paper_trail

  # Liste der manuellen Eintragungen
  has_many :subscriptions, dependent: :destroy

  # Diese Gruppe darf Emails senden
  belongs_to :sender_group, optional: true, class_name: 'Group'
  # An diese Gruppe werden Emails gesendet
  belongs_to :receiver_group, optional: true, class_name: 'Group'
  # Diese Gruppe ist für die Moderation zuständig
  belongs_to :moderator_group, optional: true, class_name: 'Group'

  class VirtualSubscription < Subscription
    attribute :mailinglist_id, ActiveRecord::Type::Integer.new
    attribute :email_address, ActiveRecord::Type::String.new
    attribute :as_sender, ActiveRecord::Type::Boolean.new
    attribute :as_receiver, ActiveRecord::Type::Boolean.new
    attribute :as_moderator, ActiveRecord::Type::Boolean.new
    attribute :manual, ActiveRecord::Type::Boolean.new
    self.table_name = 'all_subscriptions'
  end
  # Damit kann man auch automatische Eintragungen in eine Mailingliste abfragen
  has_many :all_subscriptions, class_name: 'Mailinglist::VirtualSubscription'

  validates :title, length: { maximum: 50 }, presence: true
  validates :description, length: { maximum: 1000 }

  # Nötig, da das Formular für Unterkünfte auch eine Liste von Eintragungen mitschickt
  accepts_nested_attributes_for :subscriptions, allow_destroy: true,
                                                reject_if: proc { |attr| reject_blank_entries attr, :email_address }
  after_initialize :set_defaults

  # Standardwerte für Emailverteiler
  def set_defaults; end

  # Ordne Emailverteiler standardmäßig alphabetisch
  default_scope { order(:title) }

  def object_name
    title
  end
end
