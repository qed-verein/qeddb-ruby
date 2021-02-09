module RegistrationsHelper

def registration_information(reg)
	words = []
	words.push "Orga" if reg.organizer
	words.push Registration.human_enum_value(:status, reg.status) if reg.status.to_sym != :confirmed
	words.empty? ? "" : tag.i {"(" + words.join(", ") + ")"}
end

def registration_link_with_name(registration)
	link_to registration.person.full_name, registration_path(registration)
end


def registration_link_with_name_fancy(registration)
	text = registration.person.full_name
	text = content_tag :del, text if registration.status == 'rejected' || registration.status == 'cancelled'
	tag.div style: 'display: inline-block' do
		concat link_to(text, registration_path(registration))
		concat " "
		concat registration_information(registration)
	end
end

def registration_link_with_event_fancy(registration)
	text = registration.event.title
	text = content_tag :del, text if registration.status == 'rejected' || registration.status == 'cancelled'
	[link_to(text, registration_path(registration)), " ", registration_information(registration)].join.html_safe
end

def edit_registration_link(registration)
	return unless policy(registration).edit_general?
	icon_button t('actions.registration.edit'), 'edit', edit_registration_path(registration)
end


def delete_registration_link(registration)
	return unless policy(registration).delete_registration?
	link_to registration, class: 'button', method: :delete, data: {
		confirm: sprintf("Anmeldung von „%s“ zur Veranstaltung „%s“ komplett löschen?",
			registration.person.full_name, registration.event.title)} do
		concat mi.delete.md_24
		concat t('actions.registration.delete')
	end
end

end
