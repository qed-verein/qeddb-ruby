# frozen_string_literal: true

json.type :Address
json.extract! address, :id, :country, :city, :postal_code, :street_name, :house_number, :address_addition, :priority
