# Klasse um Sepa-Lastschriftmandate zu speichern und Personen zuzuordnen.

class SepaMandate < ApplicationRecord
  # Versionskontrolle
  has_paper_trail

  # Zu dieser Person gehört der Kontakt
  belongs_to :person

  # Validierungen
  validates :person, :mandate_reference, :signature_date, :iban, :bic, :name_account_holder, presence: true

  # TODO: IBAN-Validierung?
end
