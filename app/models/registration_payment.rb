# Klasse um Zahlungen in Bezug auf Veranstaltungen zu speichern
class RegistrationPayment < ApplicationRecord
	# Versionskontrolle
	has_paper_trail

	# Zu dieser Person gehört der Kontakt
	belongs_to :registration

	enum payment_type: {transfer: 1, expense: 2}

	# Validierungen
	validates :registration, :payment_type, :money_transfer_date, :money_amount, presence: true
	validates :payment_type, inclusion: {in: payment_types.keys}
	validates :category, presence: true, if: :expense?
	validates :category, absence: true, unless: :expense?
	
	def object_name
		"#{registration && registration.event ? registration.event.title : 'Unknown event'} » " +
            "#{registration && registration.event ? registration && registration.person.full_name : 'Unknown person'}"
	end
end
