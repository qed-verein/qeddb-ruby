authorize_json_export(@person_policy, json) {
	json.partial! "people/person", person: @person, modules: [
		:addresses, :contacts, :payments, :registrations, :sepa_mandate]}
