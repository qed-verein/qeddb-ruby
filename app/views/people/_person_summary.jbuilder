# frozen_string_literal: true

json.extract! person, :id, :first_name, :last_name, :email_address, :mobile_number, :birthday, :gender, :account_name

json.partial! partial: 'people/sepa_mandate', person: person
json.url person_url(person, format: :json)
