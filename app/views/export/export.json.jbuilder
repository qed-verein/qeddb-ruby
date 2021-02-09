if @export_people
	json.people do
		json.array! @people, partial: 'people/person', as: :person, locals: {modules: [
			:addresses, :contacts, :payments]}
	end
end

if @export_events || @export_registrations
	json.events do
		json.array! @events, partial: 'events/event', as: :event, locals: {modules: 
			(@export_registrations ? [:registrations] : [])}
	end
	
	if @export_events
		json.hostels do
			json.array! @hostels, partial: 'hostels/hostel', as: :hostel
		end
	end
end

	
if @export_groups
	json.groups do
		json.array! @groups, partial: 'groups/group', as: :group
	end
end
	
if @export_mailinglists
	json.mailinglists do
		json.array! @mailinglists, partial: 'mailinglists/mailinglist', as: :mailinglist
	end
end
	
