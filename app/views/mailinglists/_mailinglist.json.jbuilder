json.type :Mailinglist
json.extract! mailinglist, :id, :title, :description
json.extract! mailinglist, :sender_group_id, :receiver_group_id, :moderator_group_id
json.url mailinglist_url(mailinglist, format: :json)
json.member_subscriptions mailinglist.member_subscriptions do |sub|
  json.type :MemberSubscription
  json.extract! sub, :id, :person_id, :as_sender, :as_receiver, :as_moderator
end
json.email_subscriptions mailinglist.email_subscriptions do |sub|
  json.type :EmailSubscription
  json.extract! sub, :id, :email_address, :as_sender, :as_receiver, :as_moderator
end
