json.type :Hostel
json.extract! hostel, :id, :title, :homepage, :comment
json.url hostel_url(hostel, format: :json)
json.address do
	json.partial! hostel.address, partial: 'adresses/address'
end
