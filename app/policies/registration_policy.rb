# *** Die Berechtigungsstufen für Anmeldungen ***
# view_general, edit_general:
#	 Allgemeine Informationen wie Anmeldestatus
# view_additional, edit_additional:
#	 Zusätzliche Daten wie Essenswünsche und Vorträge
# view_payments, edit_payments:
#	 Seminarbeiträge des Teilnehmer
# view_private:
#	 Anzeige von privaten Daten des Teilnehmer (wie Geburtstag)
# view_dummy:
#	 Anzeige von dummy-Anmeldungen
# delete_registration
#	 Anmeldung löschen
# by_other:
#	 Das können andere Personen in der Datenbank tun
# by_member:
#	 Das können andere Vereinsmitglieder tun
# by_participant:
#	 Das können andere Teilnehmer der Veranstaltung tun
# by_self:
#	 Das kann eine Person mit seiner eigenen Anmeldung tun
# by_organizer:
#	 Das können Organisatoren mit den Anmeldungen der Teilnehmer tun
# by_board_member:
#	 Das können alle Vereinsvorstände tun
# by_treasurer:
#	 Das kann der Kassier tun
# by_auditor:
#	 Das dürfen Kassenprüfer:innen tun
# by_admin
#   Das dürfen Administratoren tun

class RegistrationPolicy < ApplicationPolicy
  include PunditImplications
  include PolicyHelper

  define_implications(
    {
      edit_general: [:view_general],
      edit_payments: [:view_payments],
      edit_additional: [:view_additional],
      view_private: %i[view_general view_additional view_dummy],

      by_other: [],
      by_member: [:view_general],
      by_participant: %i[by_other view_general view_additional],
      by_self: %i[by_participant view_private edit_additional view_payments],
      by_organizer: %i[by_participant view_private edit_additional edit_general export],
      by_board_member: %i[by_organizer delete_registration],
      by_treasurer: %i[by_board_member view_payments edit_payments],
      by_auditor:	%i[by_participant view_payments export], # TODO: Check if that is everything reasonable
      by_admin: [:by_board_member]
    }
  )

  # TODO: Rechtesystem für Veranstaltung und Person prüfen
  def initialize(user_context, reg)
    super
    grant :by_admin if active_admin?(@user, @mode)
    grant :by_treasurer if active_treasurer?(@user, @mode)
    grant :by_auditor if active_auditor?(@user, @mode)
    grant :by_board_member if active_board_member?(@user, @mode)
    grant :by_organizer if reg.is_a?(Registration) &&
                           @user.organizer?(reg.event) && reg.event.still_organizable?
    grant :by_self if reg.is_a?(Registration) && !reg.person.nil? && @user.id == reg.person.id
    grant :by_participant if reg.is_a?(Registration) && @user.participant?(reg.event)
    grant :by_member if @user.member? && !reg.person.nil? && reg.person.member? && reg.person.publish
    grant :by_other
  end

  # Diese Attribute können von dem Benutzer verändert werden.
  def permitted_attributes
    editable = []
    if edit_general?
      editable.push :event_id, :person_id, :status, :organizer
      editable.push({ charge_modifiers_attributes: %i[id reason comment _destroy] })
    end
    if edit_additional?
      editable.push :arrival, :departure, :nights_stay,
                    :station_arrival, :station_departure, :railway_discount,
                    :meal_preference, :talks, :comment, :terms_of_service
    end
    if edit_payments?
      editable.push :payment_complete, :money_transfer_date, :other_discounts
      editable.push({ registration_payments_attributes:
        %i[id payment_type money_amount category money_transfer_date comment _destroy] })
    end
    editable
  end
end
