class EventPayment < ApplicationRecord
  # Versionskontrolle
  has_paper_trail

  # Zu dieser Veranstaltung gehört die Zahlung
  belongs_to :event
  default_scope { order(money_transfer_date: :desc) }

  # Validierungen
  validates :money_transfer_date, :money_amount, :category, presence: true

  def object_name
    (event ? event.title : 'Unknown event').to_s
  end
end
