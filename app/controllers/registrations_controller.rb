class RegistrationsController < ApplicationController
  breadcrumb Event.model_name.human(count: :other), :events_path

  before_action :set_registration, only: %i[show edit update destroy edit_self update_self pay_rest]
  before_action :set_event_and_person,
                only: %i[new create new_self create_self select_person with_selected_person edit_self]
  before_action :basic_authorization
  before_action :deadline_check, only: %i[new_self create_self edit_self update_self]
  before_action :capacity_check, only: %i[new_self create_self]

  # Anmeldung eines Benutzers anzeigen
  def show
    # leer, da Standardverhalten
  end

  # *****************************************************************
  # Die Funktionen new, create, edit, update und destroy dienen dazu,
  # dass Organisatoren einen anderen Benutzer anmelden können.
  # *****************************************************************

  # Noch keine Personen ausgewählt --> Zeige erst ein Auswahlfeld für Personen an
  def select_person
    @registration = Registration.new(event: @event)
  end

  # Person wurde ausgewählt --> Leite zum Formular mit den restlichen Feldern weiter
  def with_selected_person
    redirect_to event_register_person_path(@event, @person)
  end

  # Formularanzeige, wenn Organisatoren einen Benutzer anmelden wollen.
  def new
    @registration = Registration.new(event: @event, person: @person)
    @registration.set_defaults
    @registration_policy = policy(@registration)
  end

  # Formularanzeige, wenn Organistoren eine Anmeldung ändern wollen.
  def edit; end

  # Die Organisatoren haben eine Anmeldung erstellt. Speichere diese in der Datenbank.
  def create
    @registration = Registration.new(event: @event, person: @person)
    @registration_policy = policy(@registration)
    @registration.assign_attributes(permitted_attributes(@registration))
    @registration.set_defaults
    if @registration.save
      # Verschicke Emails an die angemeldete Person
      mailer = RegistrationMailer.with(registration: @registration)
      mailer.new_registration_for_participant_by_organizer_email.deliver_now
      redirect_to @registration, notice: t('.success')
    else
      render :new
    end
  end

  # Änderungen an der Anmeldung durch Organisatoren speichern.
  def update
    if @registration.update(permitted_attributes(@registration))
      redirect_to @registration, notice: t('.success')
    else
      render :edit
    end
  end

  # Anmeldung eines Teilnehmer komplett löschen
  def destroy
    @registration.destroy
    redirect_to event_url(@registration.event), notice: t('.success')
  end

  def pay_rest
    begin
      date = Date.parse(params[:pay_rest_date])
    rescue ArgumentError
      return redirect_to @registration, alert: t('.invalid_date')
    end

    amount = @registration.to_be_paid

    return redirect_to @registration, alert: t('.no_rest_to_be_paid') if amount.zero?

    @registration.add_transfer(date, @registration.to_be_paid)
    redirect_to @registration, notice: t('.success')
  end

  # ****************************************************************************
  # Die Funktionen new_self, create_self, edit_self und update_self dienen dazu,
  # dass sich ein Benutzer sich selber selbständig anmelden kann.
  # ****************************************************************************

  # Formularanzeige, wenn sich der Benutzer selber anmeldet.
  def new_self
    @registration = Registration.new(event: @event, person: current_user)
    @registration.set_defaults
    @registration_policy = policy(@registration)
  end

  # Der Benutzer hat seine Anmeldung erstellt. Speichere diese in der Datenbank.
  def create_self
    @registration = Registration.new(event: @event, person: current_user)
    @registration_policy = policy(@registration)
    @registration.assign_attributes(permitted_attributes(@registration))
    @registration.set_defaults
    if @registration.save
      # Verschicke Emails an die angemeldete Person sowie an die Organisatoren
      mailer = RegistrationMailer.with(registration: @registration)
      mailer.new_registration_for_participant_email.deliver_now
      mailer.new_registration_for_organizer_email.deliver_now
      redirect_to @registration.event, notice: t('.success')
    else
      render :new_self
    end
  end

  # Bearbeiten einer bereits vorhandenen Anmeldung.
  def edit_self
    # leer, da Standardverhalten
  end

  # Übernehmen der Änderungen des Benutzers in die Datenbank.
  def update_self
    if @registration.update(permitted_attributes(@registration))
      # Verschicke Emails an die angemeldete Person sowie an die Organisatoren
      mailer = RegistrationMailer.with(registration: @registration)
      mailer.edit_registration_for_participant_email.deliver_now
      mailer.edit_registration_for_organizer_email.deliver_now
      redirect_to @registration, notice: t('.success')
    else
      render :edit_self
    end
  end

  private

  # Lade Anmeldung aus der Datenbank
  def set_registration
    @registration = Registration.find(params[:id])
    @registration_policy = policy(@registration)
    breadcrumb @registration.event.title, @registration.event
    breadcrumb @registration.person.full_name, @registration
  end

  # Lade Veranstaltung und Person aus der Datenbank
  # (falls noch keine Anmeldung erstellt wurde)
  def set_event_and_person
    @person = Person.find(params[:person_id]) if params[:person_id]
    @event = Event.find(params[:event_id]) if params[:event_id]
  end

  # Grundlegende Zugriffsprüfung für Anmeldungen.
  def basic_authorization
    case action_name.to_sym
    when :show
      authorize @registration, :view_general?
    when :new, :create, :select_person, :with_selected_person
      authorize @event, :register_other?
    when :edit, :update
      authorize @registration, :edit_general?
    when :new_self, :create_self
      authorize @event, :register_self?
    when :edit_self, :update_self
      authorize @registration, :edit_additional?
    when :destroy
      authorize @registration, :delete_registration?
    when :pay_rest
      authorize @registration, :edit_payments?
    else
      raise Pundit::NotAuthorizedError({ query: action_name, record: @registration })
    end
  end

  # Prüfe ob der Anmeldeschluss schon vorbei ist
  def deadline_check
    @event ||= @registration.event
    return unless @event.deadline_missed?

    redirect_to event_path(@event), alert: t('registrations.deadline_missed')
  end

  # Prüfe ob noch freie Plätze da sind
  def capacity_check
    return unless @event.full? && !current_user.registered?(@event)

    redirect_to event_path(@event), alert: t('registrations.event_full')
  end
end
