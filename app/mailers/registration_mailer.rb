class RegistrationMailer < ApplicationMailer
  before_action :set_registration

  def set_registration
    @registration = params[:registration]
    @person = @registration.person
    @event = @registration.event
  end

  def new_registration_for_participant_email
    mail(to: @person.email_address,	subject: format(
      'Anmeldung zur Veranstaltung %s erfolgeich', @event.title
    ))
  end

  def new_registration_for_participant_by_organizer_email
    mail(to: @person.email_address, subject: format(
      'Anmeldung zur Veranstaltung %s', @event.title
    ))
  end

  def edit_registration_for_participant_email
    mail(to: @person.email_address,	subject: format(
      'Anmeldedaten zur Veranstaltung %s erfolgeich geändert', @event.title
    ))
  end

  def new_registration_for_organizer_email
    return unless @event.organizer_email_address

    mail(to: @event.organizer_email_address, subject: format(
      'Neue Anmeldung von %s für die Veranstaltung %s', @person.full_name, @event.title
    ))
  end

  def edit_registration_for_organizer_email
    return unless @event.organizer_email_address

    mail(to: @event.organizer_email_address, subject: format(
      'Geänderte Anmeldung von %s für die Veranstaltung %s', @person.full_name, @event.title
    ))
  end
end
