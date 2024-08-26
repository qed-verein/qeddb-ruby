json.type :RegistrationPayment
json.extract! registration_payment, :id, :money_amount, :money_transfer_date, :comment, :payment_type, :category
if modules.include? :registration_summary
  json.registration_summary do
    json.partial! 'registrations/registration_summary_for_event', registration: registration_payment.registration, modules: [:person_summary]
  end
end
