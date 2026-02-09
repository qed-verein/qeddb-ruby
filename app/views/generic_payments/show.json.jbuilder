authorize_json_export(policy(@generic_payment), json) do
  json.partial! 'generic_payments/generic_payment', generic_payment: @generic_payment
end
