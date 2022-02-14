module EventsHelper


def event_link(event)
	#~ return event.title unless policy(event).view_basic?
	link_to event.title, event_path(event)
end

def events_link
	return nil unless policy(Event).list_events?
	link_to Event.model_name.human(count: :other), events_path
end




def new_event_link
	return unless policy(Event).create_event?
	icon_button t('actions.event.new'), 'add', new_event_path
end

def event_select(form)
	form.select :event_id, Event.all.map {|e| [e.title, e.id]}, id: :event_id
end

def event_register_self_link(event)
	return nil unless policy(event).register_self?
	reg = current_user.registered?(event)
	if reg && event.can_edit_registration?
		icon_button t('actions.event.edit_own_registration'), 'assignment_turned_in', edit_own_registration_event_path(event)
	elsif !reg && event.can_create_registration?
		icon_button t('actions.event.register_self'), 'assignment_turned_in', event_register_self_path(event)
	end
end

def edit_event_link(event)
	return nil unless policy(event).edit_event?
	icon_button t('actions.event.edit'), 'edit', edit_event_path(event)
end

def delete_event_link(event)
	return nil unless policy(event).delete_event?
	link_to event, method: :delete, class: 'button',
		data: {confirm: sprintf("Veranstaltung „%s“ löschen?", event.title)} do
		concat mi.delete.md_24
		concat t('actions.event.delete')
	end
end

def event_register_other_link(event)
	return nil unless policy(event).register_other?
	icon_button t('actions.event.register_other'), 'person_add', event_register_other_path(event)
end


end
