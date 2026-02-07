authorize_json_export(policy(:generic_payment), json) do
  json.array! @generic_payments do |generic_payment|
    json.partial! 'generic_payments/generic_payment', generic_payment: generic_payment
  end
end
