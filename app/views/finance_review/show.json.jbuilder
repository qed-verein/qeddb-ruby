authorize_json_export(policy(:finance_review), json) do
json.type :FinanceReview

json.filter do
  json.extract! @filter, :start, :end, :reason
end

json.payments @payments do |payment|
    if payment.instance_of? RegistrationPayment
      json.partial! "registration_payments/registration_payment", registration_payment: payment
    else
      json.partial! "payments/payment", payment: payment
    end
end
end
