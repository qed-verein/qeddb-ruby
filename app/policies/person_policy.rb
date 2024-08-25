# *** Berechtigungsstufen für Personen ***
# view_additional, edit_additional:
#	 Zusätzliche Daten wie Adressen und Kontakte
# view_settings, edit_settings:
#	 Einstellungen zu Datenschutz und Mailinglisten
# view_payments, edit_payments:
#	 Überweisungen und Finanzen
# view_public:
#	 Anzeige aller öffentlichen Attribute (z.B. für alle Mitglieder)
# view_private:
#	 Anzeige aller privaten Attribute (z.B. nur für spezielle Personen)
# edit_personal:
#	 Persönliche Daten wie Name, Geburtstag etc. bearbeiten
# edit_basic:
#   Mindestesn ein Attribute der Person lässt sich ändern (intern für Auth benötigt)
# create_person:
#	 Neue Person eintragen
# delete_person:
#	 Person löschen
# list_published_people:
#   Anzeige aller veröffentlichen Mitglieder
# list_all_people:
#   Anzeige sämtlicher Mitglieder aufgelistet werden
# by_other:
#	 Das können andere externe Personen in der Datenbank tun
# by_member:
#	 Das können andere Vereinsmitglieder tun
# by_organizer:
#	 Das können Organisatoren an den Teilnehmern einer Veranstaltung tun
# by_self:
#	 Das kann ein Mitglied mit seinem eigenen Account tun
# by_chairman:
#	 Das können alle Vereinsvorstände tun
# by_treasurer:
#	 Das kann der Kassier tun
# by_auditor:
#	 Das können Kassenprüfer:innen tun
# by_admin
#   Das können Administratoren tun


class PersonPolicy
	include PunditImplications

	# Baut einen Abhängigkeitsgraph für die verschieden Rechtestufen
	# Die Rechte auf linken Seite implizieren die Rechte auf rechten Seite
	#   :edit => [:view]  heißt z.B., was bearbeitet werden kann, kann auch angezeigt werden
	# Transitive Beziehungen werden erkannt.

	define_implications({
			edit_personal:	  [:view_private, :edit_basic],
			edit_additional:  [:view_additional, :view_addresses, :view_contacts, :edit_basic],
			edit_settings:	  [:view_settings, :edit_basic],
			edit_payments:	  [:view_payments],
			edit_sepa_mandate:[:view_sepa_mandate],

			view_public:	  [:view_additional],
			view_private:	  [:view_public, :view_payments, :view_addresses, :view_contacts, :view_settings, :export],

			list_all_people:  [:list_published_people],
			create_person:    [:edit_personal, :edit_additional, :edit_settings],

			by_other:         [],
			by_member:        [:view_public, :list_published_people],
			by_organizer:     [:by_member, :view_private, :view_settings],
			by_self:          [:by_member, :view_private, :edit_additional, :edit_settings, :view_sepa_mandate],
			by_chairman:      [:by_self, :edit_personal, :create_person, :delete_person, :list_all_people],
			by_treasurer:     [:by_chairman, :edit_payments, :edit_sepa_mandate],
			by_admin:         [:by_chairman]})

	# Vergibt die Rechtestufen, je nachdem ob der Benutzer ein Mitglieder, Admin etc. ist
	# Dabei werden obige Implikationen automatisch berücksichtigt.
	def initialize(user, person)
		grant :by_admin if user.admin?
		grant :by_treasurer if user.treasurer?
		grant :by_auditor if user.auditor?
		grant :by_chairman if user.chairman?
		grant :by_self if person.is_a?(Person) && user.id == person.id
		grant :by_organizer if person.is_a?(Person) && user.organizer_of_person_now?(person)

		if person.is_a?(Person) && user.member? && person.publish
			grant :by_member
			grant :view_addresses if person.publish_address
			grant :view_contacts if person.publish_address
		end

		grant :by_member if person == Person && user.member?
		grant :by_other
	end

	# Hier werden die änderbaren Attribute für die verschiedenen Rechtestufen angegeben
	def permitted_attributes
		editable = []
		if edit_additional?
			editable.push :railway_station, :railway_discount, :meal_preference, :comment
			editable.push({:addresses_attributes =>
				[:id, :country, :city, :postal_code, :street_name, :house_number, :address_addition,
					:priority, :_destroy]})
			editable.push({:contacts_attributes =>
				[:id, :protocol, :identifier, :priority, :_destroy]})
		end
		if edit_settings?
			editable.push :password, :password_confirmation, :email_address,
				:newsletter, :photos_allowed, :publish_birthday, :publish_email, :publish_address, :publish
		end
		if edit_personal?
			editable.push :account_name,  :first_name, :last_name, :birthday, :gender, :joined, :quitted, :active
		end
		if edit_payments?
			editable.push({payments_attributes:
				[:id, :payment_type, :start, :end, :transfer_date, :amount, :comment, :_destroy]})
		end
		if edit_sepa_mandate?
			editable.push({sepa_mandate_attributes: [
				:id, :mandate_reference, :signature_date, :iban, :bic, :name_account_holder, :sequence_type, :sponsor_membership, :allow_all_payments, :_destroy]})
		end
		editable
	end

	# Scopes schränken die Menge der anzeigbaren Personen ein,
	#   (was man für nicht öffentliche Mitgliederprofile braucht)
	class Scope
		attr_reader :user, :scope

		def initialize(user, scope)
			@user = user
			@scope = scope
		end

		def resolve
			if Pundit.policy!(user, Person).list_all_people?
				scope.all
			elsif Pundit.policy!(user, Person).list_published_people?
				scope.where('(active=? AND publish=?) OR id=?', true, true, user.id)
			else
				scope.where(id: user.id)
			end
		end
	end
end
