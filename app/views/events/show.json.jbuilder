authorize_json_export(@event_policy, json) do
  json.partial! 'events/event', event: @event, modules: %i[registrations person_summary payments]
end
