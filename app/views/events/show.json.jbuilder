authorize_json_export(@event_policy, json) {
	json.partial! "events/event", event: @event, modules: [:registrations, :person_summary]}
