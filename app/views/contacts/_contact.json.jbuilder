# frozen_string_literal: true

json.type :Contact
json.extract! contact, :id, :protocol, :identifier, :priority
