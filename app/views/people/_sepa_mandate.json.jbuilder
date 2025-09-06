# frozen_string_literal: true

if policy(person).view_sepa_mandate?
  json.sepa_mandate do
    if person.sepa_mandate.nil?
      json.nil!
    else
      json.extract! person.sepa_mandate, :mandate_reference, :signature_date, :iban, :bic, :name_account_holder, :sponsor_membership, :allow_all_payments,
                    :sequence_type, :sponsor_membership
    end
  end
end
