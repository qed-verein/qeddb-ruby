json.extract! registration, :id, :person_id, :organizer, :status
json.person_summary do
  json.partial! 'people/person_summary', person: registration.person
end
json.url registration_url(registration, format: :json)
