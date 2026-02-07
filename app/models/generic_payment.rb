class GenericPayment < ApplicationRecord
  # Versionskontrolle
  has_paper_trail

  default_scope { order(money_transfer_date: :desc) }

  # Validierungen
  validates :counterparty, :money_transfer_date, :money_amount, :category, presence: true
end
