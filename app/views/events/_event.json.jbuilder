json.type :Event
json.extract! event, :id, :title, :homepage, :start, :end, :deadline,
	:cost, :max_participants, :hostel_id, :comment
json.url event_url(event, format: :json)

rmodules = modules.include?(:person_summary) ? [:person_summary] : []

if modules.include? :registrations_summary
	json.registrations_summary do
		json.array! event.registrations, partial: 'registrations/registration_summary_for_event', 
			as: :registration, locals: {modules: rmodules}
	end
end

if modules.include? :registrations
	json.registrations do
		json.array! event.registrations, partial: 'registrations/registration', as: :registration, 
			locals: {modules: rmodules}
	end
end
