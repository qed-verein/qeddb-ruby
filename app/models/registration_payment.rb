# Klasse um Zahlungen in Bezug auf Veranstaltungen zu speichern
class RegistrationPayment < ApplicationRecord
  # Versionskontrolle
  has_paper_trail

  # Zu dieser Person gehört der Kontakt
  belongs_to :registration

  # Validierungen
  validates :registration, :money_transfer_date, :money_amount, presence: true
end
