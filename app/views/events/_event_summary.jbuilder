# frozen_string_literal: true

json.extract! event, :id, :title, :homepage, :start, :end
json.url event_url(event, format: :json)
