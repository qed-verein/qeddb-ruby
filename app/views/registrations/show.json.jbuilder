# frozen_string_literal: true

authorize_json_export(@registration_policy, json) do
  json.partial! 'registrations/registration', registration: @registration, modules:
    %i[person_summary event_summary]
end
