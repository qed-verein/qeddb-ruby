json.type :Mailinglist
json.extract! mailinglist, :id, :title, :description
json.extract! mailinglist, :sender_group_id, :receiver_group_id, :moderator_group_id
json.url mailinglist_url(mailinglist, format: :json)
json.mailinglist_members mailinglist.mailinglist_members do |sub|
  json.type :MailinglistMember
  json.extract! sub, :id, :person_id, :as_sender, :as_receiver, :as_moderator
end
json.subscriptions mailinglist.subscriptions do |sub|
  json.type :Subscription
  json.extract! sub, :id, :email_address, :as_sender, :as_receiver, :as_moderator
end
