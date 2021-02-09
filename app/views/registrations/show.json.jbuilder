authorize_json_export(@registration_policy, json) {
	json.partial! "registrations/registration", registration: @registration, modules:
		[:person_summary, :event_summary]}
