# Die Klasse "Hostel" verwaltet eine einzelne Unterkunft. 

class Hostel < ApplicationRecord
	# Versionskontrolle
	has_paper_trail
	
	# Dies Adresse der Unterkunft
	has_one :address, as: :addressable, inverse_of: :addressable
	# Zu diesen Veranstaltungen gehört die Unterkunft
	has_many :events, dependent: :nullify
	
	# Validierungen
	validates :title, presence: true
	validates :title, length: {maximum: 100}
	validates :homepage, length: {maximum: 200}
	validates :comment, length: {maximum: 1000}
	
	# Nötig, da das Formular für Unterkünfte auch eine Adresse mitschickt
	accepts_nested_attributes_for :address
end
