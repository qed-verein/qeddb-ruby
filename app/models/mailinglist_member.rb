# Die Klasse "MailinglistMember" dient zur Verwaltung eines einzelnen Mailing-Abonenten (mit DB-Profil).

class MailinglistMember < ApplicationRecord
  # Versionskontrolle
  has_paper_trail

  validates :person_id, presence: true, uniqueness: {scope: :mailinglist_id,
                                    message: "sollte nur einmal auf Mailingliste eingetragen sein"}

  # Zu diese Verteiler gehört das Abonnement
  belongs_to :mailinglist
  belongs_to :person 
end
