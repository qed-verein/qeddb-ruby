module ImportHelper
  def import_link
    return unless policy(:database).import?

    link_to t('actions.import.prepare'), import_path
  end

  def import_object(data, klass)
    description = "*** #{data[:type]} #{data[:id]} ***"
    if data[:type] != klass.name
      return [description, format(
        'Invalid object type: found %<type>s, expected %<class_name>s',
        type: data[:type], class_name: klass.name
      )]
    end

    object = klass.find_by(id: data[:id]) || klass.new
    object.assign_attributes(data.slice(*klass.column_names.map(&:to_sym)))
    unless object.valid?
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
      # Importiere alle Adressen
      # Importiere alle Kontakte
      # Importiere alle Zahlungen
      input[:people]&.each do |person|
        errors.push import_object(person, Person)

        # Importiere alle Adressen
        person[:addresses]&.each do |address|
          errors.push import_object(
            address.merge({
                            addressable_id: person[:id],
                            addressable_type: 'Person'
                          }), Address
          )
        end

        # Importiere alle Kontakte
        person[:contacts]&.each do |contact|
          errors.push import_object(
            contact.merge({ person_id: person[:id] }), Contact
          )
        end

        # Importiere alle Zahlungen
        person[:payments]&.each do |payment|
          errors.push import_object(
            payment.merge({ person_id: person[:id] }), Payment
          )
        end
      end

      # Importiere alle Veranstaltungen
      # Importiere alle Anmeldungen
      input[:events]&.each do |event|
        errors.push import_object(event, Event)

        # Importiere alle Anmeldungen
        event[:registrations]&.each do |registration|
          errors.push import_object(
            registration.merge({ event_id: event[:id] }), Registration
          )
        end
      end

      # Importiere alle Unterkünfte
      # Importiere die Adresse der Unterkunft
      input[:hostels]&.each do |hostel|
        errors.push import_object(hostel, Hostel)

        # Importiere die Adresse der Unterkunft
        errors.push import_object(
          hostel[:address].merge({ addressable_id: hostel[:id], addressable_type: 'Hostel' }), Address
        )
      end

      # Importiere alle Gruppen
      # Importiere alle Einträge einer Gruppe
      input[:groups]&.each do |group|
        errors.push import_object(group, Group)

        # Importiere alle Einträge einer Gruppe
        group[:timeless_entries]&.each do |entry|
          errors.push import_object(
            entry.merge({ group_id: group[:id] }), Affiliation
          )
        end
      end

      # Importierte alle Emailverteiler
      # Importiere alle Abonnements eines Emailverteilers
      input[:mailinglists]&.each do |mailinglist|
        errors.push import_object(mailinglist, Mailinglist)

        # Importiere alle Abonnements eines Emailverteilers
        mailinglist[:subscriptions]&.each do |subscription|
          errors.push import_object(
            subscription.merge({ mailinglist_id: mailinglist[:id] }), Subscription
          )
        end
      end

      errors.compact!
      errors.flatten!
      errors.join("\n")
    end
  end
end
