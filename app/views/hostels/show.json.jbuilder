authorize_json_export(@hostel_policy, json) {
	json.partial! "hostels/hostel", hostel: @hostel}
