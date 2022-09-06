authorize_json_export(@person_policy, json) {
  json.array! @people do |person|
    json.partial! "people/person", person: person, modules: [
      :addresses, :contacts, :payments, :registrations, :sepa_mandate]
  end
}
