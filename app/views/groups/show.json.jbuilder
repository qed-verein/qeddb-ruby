authorize_json_export(@group_policy, json) {
	json.partial! "groups/group", group: @group}
