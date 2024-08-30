class EventPayment < ApplicationRecord
	# Versionskontrolle
	has_paper_trail

	# Zu dieser Veranstaltung gehört die Zahlung
	belongs_to :event
	default_scope { order(money_transfer_date: :desc) }

	# Validierungen
	validates :event, :money_transfer_date, :money_amount, :category, presence: true
end
