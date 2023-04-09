# Die Klasse "Subscription" dient zur Verwaltung eines einzelnen Emailabonnements.

class Subscription < ApplicationRecord
	# Versionskontrolle
	has_paper_trail

	# Zu diese Verteiler gehört das Abonnement
	belongs_to :mailinglist
	validates :mailinglist, :email_address, presence: true

	# Ordne Adressen standardmäßig alphabetisch
	default_scope {order('LOWER(email_address) ASC')}

	def object_name
		(mailinglist ? mailinglist.title : "Unknown mailinglist") + " » " + email_address
	end
end
