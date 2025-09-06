json.extract! registration, :id, :event_id, :organizer, :status
json.event_summary do
  json.partial! 'events/event_summary', event: registration.event
end
json.url registration_url(registration, format: :json)
