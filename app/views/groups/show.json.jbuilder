authorize_json_export(@group_policy, json) do
  json.partial! 'groups/group', group: @group
end
