json.extract! person, :id, :first_name, :last_name, :email_address, :mobile_number, :birthday, :gender
json.url person_url(person, format: :json)
