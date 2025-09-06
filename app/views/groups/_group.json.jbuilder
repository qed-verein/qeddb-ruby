json.type :Group
json.extract! group, :id, :title, :description, :mode, :program, :event_id
json.url group_url(group, format: :json)

json.timeless_entries group.timeless_entries do |entry|
  json.type :Affiliation
  json.extract! entry, :id, :groupable_id, :groupable_type, :start, :end
end
