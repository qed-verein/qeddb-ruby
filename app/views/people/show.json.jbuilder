authorize_json_export(@person_policy, json) do
  json.partial! 'people/person', person: @person, modules: %i[
    addresses contacts payments registrations sepa_mandate
  ]
end
