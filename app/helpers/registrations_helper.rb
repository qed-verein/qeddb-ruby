module RegistrationsHelper
  def registration_information(reg)
    words = []
    words.push 'Orga' if reg.organizer
    unless %i[confirmed pending].include?(reg.status.to_sym)
      words.push Registration.human_enum_value(:status, reg.status)
    end
    if policy(reg).view_payments? && !reg.fully_paid?
      amount_open = reg.to_be_paid
      if amount_open.positive?
        words.push t('.unpaid')
      elsif amount_open.negative?
        words.push t('.overpaid')
      end
    end
    words.empty? ? '' : tag.i { "(#{words.join(', ')})" }
  end

  def registration_link_with_name(registration)
    return nil if registration.status == 'dummy' && !policy(registration).view_dummy?
    return registration.person.full_name unless policy(registration).view_general?

    link_to registration.person.full_name, registration_path(registration)
  end

  def registration_link_with_name_fancy(registration)
    return nil if registration.status == 'dummy' && !policy(registration).view_dummy?

    text = registration.person.full_name
    text = content_tag :del, text if %w[rejected cancelled dummy].include?(registration.status)
    tag.span style: 'display: inline-block' do
      if policy(registration).view_general?
        concat link_to(text, registration_path(registration))
      else
        concat text
      end
      concat ' '
      concat registration_information(registration)
    end
  end

  def registration_link_with_event_fancy(registration)
    return nil if registration.status == 'dummy' && !policy(registration).view_dummy?

    text = registration.event.title
    text = content_tag :del, text if %w[rejected cancelled dummy].include?(registration.status)
    tag.span style: 'display: inline-block' do
      if policy(registration).view_general?
        concat link_to(text, registration_path(registration))
      else
        concat text
      end
      concat ' '
      concat registration_information(registration)
    end
  end

  def edit_registration_link(registration)
    return unless policy(registration).edit_general?

    icon_button t('actions.registration.edit'), 'edit', edit_registration_path(registration)
  end

  def delete_registration_link(registration)
    return unless policy(registration).delete_registration?

    link_to registration, class: 'button', method: :delete, data: {
      confirm: format(
        'Anmeldung von „%<name>s“ zur Veranstaltung „%<event_title>s“ komplett löschen?',
        name: registration.person.full_name,
        event_title: registration.event.title
      )
    } do
      concat mi.delete.md_24
      concat t('actions.registration.delete')
    end
  end
end
