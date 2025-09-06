authorize_json_export(policy(:finance_review), json) do
  json.type :FinanceReview

  json.filter do
    json.extract! @filter, :start, :end, :reason
  end

  json.payments @payments do |payment|
    case payment
    when RegistrationPayment
      json.partial! 'registration_payments/registration_payment',
                    registration_payment: payment, modules: [:registration_summary]
    when EventPayment
      json.partial! 'event_payments/event_payment', event_payment: payment, modules: [:event_summary]
    when Payment
      json.partial! 'payments/payment', payment: payment, modules: [:person_summary]
    end
  end
end
