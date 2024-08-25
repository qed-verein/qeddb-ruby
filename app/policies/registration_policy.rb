# *** Die Berechtigungsstufen für Anmeldungen ***
# view_general, edit_general:
#	 Allgemeine Informationen wie Anmeldestatus
# view_additional, edit_additional:
#	 Zusätzliche Daten wie Essenswünsche und Vorträge
# view_payments, edit_payments:
#	 Seminarbeiträge des Teilnehmer
# view_private:
#	 Anzeige von privaten Daten des Teilnehmer (wie Geburtstag)
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
# by_chairman:
#	 Das können alle Vereinsvorstände tun
# by_treasurer:
#	 Das kann der Kassier tun
# by_auditor:
#	 Das dürfen Kassenprüfer:innen tun
# by_admin
#   Das dürfen Administratoren tun

class RegistrationPolicy
	include PunditImplications

	define_implications({
			edit_general:        [:view_general],
			edit_payments:       [:view_payments],
			edit_additional:     [:view_additional],
			view_private:        [:view_general, :view_additional],

			by_other:            [],
			by_member:           [:view_general],
			by_participant:      [:by_other, :view_general, :view_additional],
			by_self:             [:by_participant, :view_private, :edit_additional],
			by_organizer:        [:by_self, :edit_general, :export],
			by_chairman:         [:by_organizer, :delete_registration],
			by_treasurer:        [:by_chairman, :edit_payments],
			by_auditor:			 [:by_participant, :view_payments], # TODO: Check if that is everything reasonable
			by_admin:            [:by_chairman]})

	# TODO Rechtesystem für Veranstaltung und Person prüfen
	def initialize(user, reg)
		grant :by_admin if user.admin?
		grant :by_treasurer if user.treasurer?
		grant :by_auditor if user.auditor?
		grant :by_chairman if user.chairman?
		grant :by_organizer if reg.is_a?(Registration) &&
			user.organizer?(reg.event) && reg.event.still_organizable?
		grant :by_self if reg.is_a?(Registration) && !reg.person.nil? && user.id == reg.person.id
		grant :by_participant if reg.is_a?(Registration) && user.participant?(reg.event)
		grant :by_member if user.member?
		grant :by_other
	end

	# Diese Attribute können von dem Benutzer verändert werden.
	def permitted_attributes
		editable = []
		if edit_general?
			editable.push :event_id, :person_id, :status, :organizer, :money_amount
		end
		if edit_additional?
			editable.push :arrival, :departure, :nights_stay,
				:station_arrival, :station_departure, :railway_discount,
				:meal_preference, :talks, :comment, :terms_of_service
		end
		if edit_payments?
			editable.push :payment_complete, :money_transfer_date, :other_discounts
			editable.push({registration_payments_attributes:
				[:id, :payment_type, :category, :money_transfer_date, :money_amount, :comment, :_destroy]})
		end
		editable
	end
end
