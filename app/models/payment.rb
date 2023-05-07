# Die Klasse "Payment" verwaltet eine Mitgliedschaftszahlung.
# Hierzu gehören alle normalen Mitgliedszahlungen, aber auch Fördermitgliedschaften etc.
# Nicht erfasst werden hier veranstaltungsspezifische Zahlungen.
# Diese müssen in der jeweiligen Anmeldung der Person eingetragen werden (siehe Registration).

class Payment < ApplicationRecord
	# Versionkontrolle
	has_paper_trail

	# Zu dieser Person gehört die Zahlung
	belongs_to :person

	# Ordne Zahlungen nach der Zeit
	default_scope { order(end: :desc) }

	# Art der Mitgliedschaftszahlung:
	#  regular_member: Reguläre Mitgliedszahlung
	#  sponsor_member: Fördermitgliedschaft
	#  donation: Spende
	#  other: sonstige
	#  free_member: kostenlose Mitgliedschaft (Preis o.ä.)
	#  sponsor_and_member: Fördermitgliedschaft mit Mitgliedschaft
	enum payment_type: { regular_member: 1, sponsor_member: 2, donation: 3, other: 4, free_member: 5,
																						sponsor_and_member: 6 }

	validates :comment, length: { maximum: 1000 }
	validates :payment_type, inclusion: { in: payment_types.keys }
	validates :start, :end, presence: true

	# Aktualisiere den Mitgliedsstatus einer Person, wenn eine Zahlung eintragen wird
	after_save :update_membership_status

	def update_membership_status
		person.update_membership_status
		person.update({ paid_until: person.paid_until, member_until: person.member_until })
	end

	def object_name
		person ? person.full_name : 'Payment'
	end
end
