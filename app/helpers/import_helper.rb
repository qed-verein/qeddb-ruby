module ImportHelper

def import_link
	return unless policy(:database).import?
	link_to t('actions.import.prepare'), import_path
end

def import_object(data, klass)
	description = "*** " + data[:type] + " " + data[:id].to_s + " ***"
	if data[:type] != klass.name
		return [description, sprintf("Invalid object type: found %s, expected %s",
			data[:type], klass.name)]
	end

	object = klass.find_by(id: data[:id]) || klass.new
	object.assign_attributes(data.slice(*klass.column_names.map(&:to_sym)))
	if !object.valid?
		object.save!(validate: false)
		return [description] + object.errors.full_messages
	end
	object.save!(validate: false)
	nil
end

def import_json(input)
	ActiveRecord::Base.transaction do
		errors = []

		# Importiere alle Personen
		input[:people].each {|person|
			errors.push import_object(person, Person)

			# Importiere alle Adressen
			person[:addresses].each {|address|
				errors.push import_object(
					address.merge({
					 addressable_id: person[:id],
					 addressable_type: "Person"}), Address)} if person[:addresses]

			# Importiere alle Kontakte
			person[:contacts].each {|contact|
				errors.push import_object(
					contact.merge({person_id: person[:id]}), Contact)} if person[:contacts]

			# Importiere alle Zahlungen
			person[:payments].each {|payment|
				errors.push import_object(
					payment.merge({person_id: person[:id]}), Payment)} if person[:payments]
		} if input[:people]

		# Importiere alle Veranstaltungen
		input[:events].each {|event|
			errors.push import_object(event, Event)

			# Importiere alle Anmeldungen
			event[:registrations].each {|registration|
				errors.push import_object(
					registration.merge({event_id: event[:id]}), Registration)} if event[:registrations]
			} if input[:events]

		# Importiere alle Unterkünfte
		input[:hostels].each {|hostel|
			errors.push import_object(hostel, Hostel)

			# Importiere die Adresse der Unterkunft
			errors.push import_object(hostel[:address].merge({
					 addressable_id: hostel[:id],
					 addressable_type: "Hostel"}), Address)} if input[:hostels]

		# Importiere alle Gruppen
		input[:groups].each {|group|
			errors.push import_object(group, Group)

			# Importiere alle Einträge einer Gruppe
			group[:timeless_entries].each {|entry|
				errors.push import_object(
					entry.merge({group_id: group[:id]}), Affiliation)} if group[:timeless_entries]
			} if input[:groups]

		# Importierte alle Emailverteiler
		input[:mailinglists].each {|mailinglist|
			errors.push import_object(mailinglist, Mailinglist)

			# Importiere alle Abonnements eines Emailverteilers
			mailinglist[:subscriptions].each {|subscription|
				errors.push import_object(subscription.merge({
					mailinglist_id: mailinglist[:id]}), Subscription)} if mailinglist[:subscriptions]
			} if input[:mailinglists]

		errors.compact!
		errors.flatten!
		errors.join("\n")
	end
end

end
