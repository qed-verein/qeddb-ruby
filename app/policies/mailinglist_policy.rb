class MailinglistPolicy < AdminPolicy
  def permitted_attributes
    [:id, :title, :description, :public_email_address, :can_unsubscribe,
     :sender_group_id, :receiver_group_id, :moderator_group_id,
     { email_subscriptions_attributes: %i[id email_address first_name last_name as_sender as_receiver as_moderator] },
    { member_subscriptions_attributes: %i[id person_id as_sender as_receiver as_moderator]}]
  end
end
