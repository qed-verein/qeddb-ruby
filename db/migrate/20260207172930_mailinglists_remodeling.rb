class MailinglistsRemodeling < ActiveRecord::Migration[6.1]
  def change
    rename_table :subscriptions, :email_subscriptions

    create_table :member_subscriptions do |t| 
      t.belongs_to :mailinglist, null: false
      t.belongs_to :person, null: false
      t.boolean :as_sender, null: false
      t.boolean :as_receiver, null: false
      t.boolean :as_moderator, null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

    update_view :all_subscriptions, version: 2, revert_to_version: 1

  end
end
