json.type :Registration
json.extract! registration, :id

json.extract! registration, :event_id
if modules.include? :event_summary
	json.event_summary do
		json.partial! 'events/event_summary', event: registration.event
	end
end

json.extract! registration, :person_id
if modules.include? :person_summary
	json.person_summary do
		json.partial! 'people/person_summary', person: registration.person
	end
end

json.extract! registration, :status, :organizer
json.extract! registration, :arrival, :departure, :nights_stay,
	:station_arrival, :station_departure, :railway_discount, :meal_preference, :talks, :comment
json.extract! registration, :payment_complete, :money_amount, :money_transfer_date,
	:effective_member_discount,  :other_discounts, :reference_line

if policy(registration).view_payments?
	json.registration_payments do
		json.array! registration.registration_payments, partial: 'registration_payments/registration_payment', as: :registration_payment
	end
end
json.url registration_url(registration, format: :json)
