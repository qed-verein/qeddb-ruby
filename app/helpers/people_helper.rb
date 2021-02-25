module PeopleHelper

def person_link(person)
	#return nil unless policy(person).view_public?  # TODO zu langsam für /people/
	link_to person.full_name, person_path(person)
end

def new_person_link
	return nil unless policy(Person).create_person?
	icon_button "Neue Person eintragen", "person_add", new_person_path
end

def people_link
	return nil unless policy(Person).list_published_people?
	link_to Person.model_name.human(count: :other), people_path
end

def edit_general_person_link(person)
	return nil unless policy(person).edit_basic?
	icon_button t('actions.person.edit_general'), "edit", edit_person_path(person)
end

def edit_addresses_person_link(person)
	return nil unless policy(person).edit_additional?
	icon_button t('actions.person.edit_addresses'), "mail", edit_addresses_person_path(person)
end

def edit_privacy_person_link(person)
	return nil unless policy(person).edit_settings?
	icon_button t('actions.person.edit_privacy'), "security", edit_privacy_person_path(person)
end

def edit_payments_person_link(person)
	return nil unless policy(person).edit_payments?
	icon_button t('actions.person.edit_payments'), "attach_money", edit_payments_person_path(person)
end

def delete_person_link(person)
	return nil unless policy(person).delete_person?
	link_to person, method: :delete, class: 'button',
		data: {confirm: sprintf("Person „%s“ löschen?", person.full_name)} do
		concat mi.delete.md_24
		concat t('actions.person.delete')
	end
end

end
