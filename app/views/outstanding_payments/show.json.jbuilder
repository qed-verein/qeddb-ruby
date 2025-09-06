# frozen_string_literal: true

authorize_json_export(policy(:outstanding_payments), json) do
  json.array! @registrations, partial: 'registrations/registration', as: :registration,
                              locals: { modules: %i[person_summary event_summary] }
end
