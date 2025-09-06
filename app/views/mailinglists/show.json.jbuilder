# frozen_string_literal: true

authorize_json_export(@mailinglist_policy, json) do
  json.partial! 'mailinglists/mailinglist', mailinglist: @mailinglist
end
