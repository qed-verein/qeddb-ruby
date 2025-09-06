# frozen_string_literal: true

json.type :EventPayment
json.extract! event_payment, :id, :money_amount, :money_transfer_date, :comment, :category
if modules.include? :event_summary
  json.event_summary do
    json.partial! 'events/event_summary', event: event_payment.event
  end
end
