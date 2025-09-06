# frozen_string_literal: true

json.type :Payment
json.extract! payment, :id, :payment_type, :start, :end, :amount, :transfer_date
if modules.include? :person_summary
  json.person_summary do
    json.partial! 'people/person_summary', person: payment.person
  end
end
