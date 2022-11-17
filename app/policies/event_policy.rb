# *** Die Berechtigungsstufen für Veranstaltungen ***
# view_event, edit_event
#	 Allgemeine Daten zur Veranstaltung wie Kosten, Beginn, Ende anzeigen bzw. berbeiten
# create_event, delete_event
#	 Veranstaltung anlegen bzw. löschen
# register_other:
#   Die Person kann andere Personen zur Veranstaltung hinzufügen
# register_self
#   Die Person kann nur sich selber anmelden
# list_participants:
#	 Liste der Teilnehmer anzeigen
# by_other, by_member, by_participant, by_organizer, by_chairman etc.
#	 Analog wie bei Registrierungen

class EventPolicy
	include PunditImplications

	define_implications({
			view_event:     [:view_basic, :list_participants],
			edit_event:     [:view_event],
			register_other: [:register_self],
			export:         [:list_participants, :list_private_fields],

			by_other:       [:view_basic, :list_events, :register_self],
			by_member:      [:by_other, :view_event],
			by_participant: [:by_member],
			by_organizer:   [:by_participant, :edit_event, :register_other, :export],
			by_admin:       [:by_organizer, :create_event, :delete_event]})

	def initialize(user, event)
		grant :by_admin if user.admin? || user.chairman?
		grant :by_organizer if event.is_a?(Event) && user.organizer?(event) && event.still_organizable?
		grant :by_participant if event.is_a?(Event) && user.participant?(event)
		grant :by_member if user.member?
		grant :by_other
	end

	def permitted_attributes
		[:title, :homepage, :start, :end, :deadline, :reference_line,
			:cost, :max_participants, :hostel_id, :comment]
	end
end
