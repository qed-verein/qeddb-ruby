class CreateDatabase < ActiveRecord::Migration[6.0]
  def change
    create_table 'addresses', force: :cascade do |t|
      t.string 'addressable_type'
      t.integer 'addressable_id'
      t.string 'country'
      t.string 'city'
      t.string 'postal_code'
      t.string 'street_name'
      t.string 'house_number'
      t.string 'address_addition'
      t.integer 'priority'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.index ['addressable_id'], name: 'index_addresses_on_addressable_id'
      t.index %w[addressable_type addressable_id], name: 'index_addresses_on_addressable_type_and_addressable_id'
    end

    create_table 'affiliations', force: :cascade do |t|
      t.integer 'group_id'
      t.string 'groupable_type'
      t.integer 'groupable_id'
      t.date 'start'
      t.date 'end'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.index ['group_id'], name: 'index_affiliations_on_group_id'
      t.index %w[groupable_type groupable_id], name: 'index_affiliations_on_groupable_type_and_groupable_id'
    end

    create_table 'contacts', force: :cascade do |t|
      t.integer 'person_id'
      t.string 'protocol'
      t.string 'identifier'
      t.integer 'priority'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.index ['person_id'], name: 'index_contacts_on_person_id'
    end

    create_table 'events', force: :cascade do |t|
      t.integer 'hostel_id'
      t.string 'title'
      t.string 'homepage'
      t.date 'start'
      t.date 'end'
      t.date 'deadline'
      t.string 'cost'
      t.integer 'max_participants'
      t.text 'comment'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.index ['hostel_id'], name: 'index_events_on_hostel_id'
    end

    create_table 'groups', force: :cascade do |t|
      t.string 'title', null: false
      t.text 'description'
      t.integer 'mode'
      t.integer 'program'
      t.integer 'event_id'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.index ['event_id'], name: 'index_groups_on_event_id'
    end

    create_table 'hostels', force: :cascade do |t|
      t.string 'title'
      t.string 'homepage'
      t.text 'comment'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
    end

    create_table 'mailinglists', force: :cascade do |t|
      t.string 'title'
      t.string 'description'
      t.integer 'sender_group_id'
      t.integer 'receiver_group_id'
      t.integer 'moderator_group_id'
      t.string 'public_email_address'
      t.boolean 'can_unsubscribe'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.index ['moderator_group_id'], name: 'index_mailinglists_on_moderator_group_id'
      t.index ['receiver_group_id'], name: 'index_mailinglists_on_receiver_group_id'
      t.index ['sender_group_id'], name: 'index_mailinglists_on_sender_group_id'
    end

    create_table 'payments', force: :cascade do |t|
      t.integer 'person_id'
      t.integer 'payment_type'
      t.date 'start'
      t.date 'end'
      t.decimal 'amount'
      t.text 'comment'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.index ['person_id'], name: 'index_payments_on_person_id'
    end

    create_table 'people', force: :cascade do |t|
      t.string 'account_name'
      t.boolean 'active'
      t.string 'first_name'
      t.string 'last_name'
      t.string 'email_address'
      t.date 'birthday'
      t.integer 'gender'
      t.date 'joined'
      t.date 'quitted'
      t.date 'paid_until'
      t.date 'member_until'
      t.boolean 'newsletter'
      t.boolean 'photos_allowed'
      t.boolean 'publish_birthday'
      t.boolean 'publish_email'
      t.boolean 'publish_address'
      t.boolean 'publish'
      t.string 'railway_station'
      t.string 'railway_discount'
      t.string 'meal_preference'
      t.text 'comment'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.string 'crypted_password'
      t.string 'salt'
      t.string 'activation_state'
      t.string 'activation_token'
      t.datetime 'activation_token_expires_at'
      t.string 'reset_password_token'
      t.datetime 'reset_password_token_expires_at'
      t.datetime 'reset_password_email_sent_at'
      t.integer 'access_count_to_reset_password_page', default: 0
      t.index ['account_name'], name: 'index_people_on_account_name'
      t.index ['activation_token'], name: 'index_people_on_activation_token'
      t.index ['email_address'], name: 'index_people_on_email_address'
      t.index ['reset_password_token'], name: 'index_people_on_reset_password_token'
    end

    create_table 'registrations', force: :cascade do |t|
      t.integer 'event_id'
      t.integer 'person_id'
      t.integer 'status'
      t.boolean 'organizer'
      t.boolean 'member_discount'
      t.string 'other_discounts'
      t.date 'money_transfer_date'
      t.decimal 'money_amount'
      t.boolean 'payment_complete'
      t.datetime 'arrival'
      t.datetime 'departure'
      t.integer 'nights_stay'
      t.string 'station_arrival'
      t.string 'station_departure'
      t.string 'railway_discount'
      t.string 'meal_preference'
      t.text 'talks'
      t.text 'comment'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.index ['event_id'], name: 'index_registrations_on_event_id'
      t.index ['person_id'], name: 'index_registrations_on_person_id'
    end

    create_table 'subscriptions', force: :cascade do |t|
      t.integer 'mailinglist_id'
      t.string 'first_name'
      t.string 'last_name'
      t.string 'email_address'
      t.boolean 'as_sender'
      t.boolean 'as_receiver'
      t.boolean 'as_moderator'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.index ['mailinglist_id'], name: 'index_subscriptions_on_mailinglist_id'
    end

    create_table 'versions', force: :cascade do |t|
      t.string 'item_type', null: false
      t.integer 'item_id', null: false
      t.string 'event', null: false
      t.string 'whodunnit'
      t.text 'object', limit: 1_073_741_823
      t.datetime 'created_at'
      t.index %w[item_type item_id], name: 'index_versions_on_item_type_and_item_id'
    end

    create_view :active_affiliations
    create_view :recursive_subgroups
    create_view :recursive_members
    create_view :accounts
    create_view :all_subscriptions
  end
end
