# frozen_string_literal: true

# Klasse um Sepa-Lastschriftmandate zu speichern und Personen zuzuordnen.

class SepaMandate < ApplicationRecord
  # Versionskontrolle
  has_paper_trail

  # Zu dieser Person gehört der Kontakt
  belongs_to :person

  enum sequence_type: { first_use: 1, recurring_use: 2 }
  # Validierungen
  validates :person, :mandate_reference, :signature_date, :iban, :bic, :name_account_holder, :sequence_type,
            presence: true

  def use_mandate
    update(sequence_type: :recurring_use)
  end

  def object_name
    (person ? person.full_name : 'Unknown person').to_s
  end

  # TODO: IBAN-Validierung?
end
