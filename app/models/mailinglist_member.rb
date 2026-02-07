# Die Klasse "MailinglistMember" dient zur Verwaltung eines einzelnen Mailing-Abonenten (mit DB-Profil).

class MailinglistMember < ApplicationRecord
  # Versionskontrolle
  has_paper_trail

  # Zu diese Verteiler gehört das Abonnement
  belongs_to :mailinglist
  belongs_to :person 
end
