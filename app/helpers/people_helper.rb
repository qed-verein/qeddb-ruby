module PeopleHelper
  def person_link(person)
    if policy(person).view_public?
      link_to person.full_name, person_path(person)
    else
      person.full_name
    end
  end

  # Effizientere Version ohne Rechteprüfung (wird für /people/ gebraucht)
  def person_link_unchecked(person)
    link_to person.full_name, person_path(person)
  end

  def new_person_link
    return nil unless policy(Person).create_person?

    icon_button 'Neue Person eintragen', 'person_add', new_person_path
  end

  def people_link
    return nil unless policy(Person).list_members?

    link_to Person.model_name.human(count: :other), people_path
  end

  def edit_general_person_link(person)
    return nil unless policy(person).edit_basic?

    icon_button t('actions.person.edit_general'), 'edit', edit_person_path(person)
  end

  def edit_addresses_person_link(person)
    return nil unless policy(person).edit_additional?

    icon_button t('actions.person.edit_addresses'), 'mail', edit_addresses_person_path(person)
  end

  def edit_privacy_person_link(person)
    return nil unless policy(person).edit_settings?

    icon_button t('actions.person.edit_privacy'), 'security', edit_privacy_person_path(person)
  end

  def edit_payments_person_link(person)
    return nil unless policy(person).edit_payments?

    icon_button t('actions.person.edit_payments'), 'attach_money', edit_payments_person_path(person)
  end

  def edit_sepa_mandate_person_link(person)
    return nil unless policy(person).edit_payments?

    icon_button t('actions.person.edit_sepa_mandate'), 'attach_money', edit_sepa_mandate_person_path(person)
  end

  def delete_sepa_mandate_link(person)
    return nil unless policy(person).edit_payments?

    link_to delete_sepa_mandate_person_path(person),
            method: :delete,
            class: 'button',
            data: { confirm: "SEPA-Mandat von „#{person.full_name}“ löschen?" } do
      concat tag.i(class: 'material-icons md-24') { 'delete' }
      concat t('actions.person.delete_sepa_mandate')
    end
  end

  def delete_person_link(person)
    return nil unless policy(person).delete_person?

    link_to person, method: :delete, class: 'button',
                    data: { confirm: format('Person „%s“ löschen?', person.full_name) } do
      concat mi.delete.md_24
      concat t('actions.person.delete')
    end
  end
end
