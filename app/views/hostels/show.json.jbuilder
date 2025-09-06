# frozen_string_literal: true

authorize_json_export(@hostel_policy, json) do
  json.partial! 'hostels/hostel', hostel: @hostel
end
