# Die Klasse "Contact" verwaltet eine Kontaktmöglichkeit, wie zum Beispiel
# eine Telefonnummer, oder eine XMPP-Adresse.

class Contact < ApplicationRecord
	# Versionskontrolle
	has_paper_trail

	# Zu dieser Person gehört der Kontakt
	belongs_to :person

	# Validierungen
	validates :person, :protocol, :identifier, presence: true
	validates :protocol, length: {maximum: 30}
	validates :identifier, length: {maximum: 200}
	validates :priority, numericality: {only_integer: true, greater_than_or_equal_to: 0}, allow_blank: true

	# Ordne Kontakte standardmäßig nach Priorität
	default_scope {order('priority ASC')}
	# TODO Validierung für Email etc.

	def object_name
		person.full_name
	end
end
