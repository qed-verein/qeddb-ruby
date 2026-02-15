# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2026_02_07_172930) do

  create_table "addresses", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "addressable_type"
    t.integer "addressable_id"
    t.string "country"
    t.string "city"
    t.string "postal_code"
    t.string "street_name"
    t.string "house_number"
    t.string "address_addition"
    t.integer "priority"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["addressable_id"], name: "index_addresses_on_addressable_id"
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable_type_and_addressable_id"
  end

  create_table "affiliations", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "group_id"
    t.string "groupable_type"
    t.integer "groupable_id"
    t.date "start"
    t.date "end"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_affiliations_on_group_id"
    t.index ["groupable_type", "groupable_id"], name: "index_affiliations_on_groupable_type_and_groupable_id"
  end

  create_table "charge_modifiers", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "registration_id"
    t.decimal "money_amount", precision: 10, scale: 2
    t.string "reason"
    t.text "comment"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["registration_id"], name: "index_charge_modifiers_on_registration_id"
  end

  create_table "contacts", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "person_id"
    t.string "protocol"
    t.string "identifier"
    t.integer "priority"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_contacts_on_person_id"
  end

  create_table "email_subscriptions", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "mailinglist_id"
    t.string "first_name"
    t.string "last_name"
    t.string "email_address"
    t.boolean "as_sender"
    t.boolean "as_receiver"
    t.boolean "as_moderator"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mailinglist_id"], name: "index_email_subscriptions_on_mailinglist_id"
  end

  create_table "event_payments", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "event_id"
    t.date "money_transfer_date"
    t.decimal "money_amount", precision: 10, scale: 2
    t.string "category"
    t.text "comment"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["event_id"], name: "index_event_payments_on_event_id"
  end

  create_table "events", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "hostel_id"
    t.string "title"
    t.string "homepage"
    t.date "start"
    t.date "end"
    t.date "deadline"
    t.decimal "cost", precision: 10, scale: 2
    t.integer "max_participants"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reference_line"
    t.index ["hostel_id"], name: "index_events_on_hostel_id"
  end

  create_table "generic_payments", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "counterparty"
    t.date "money_transfer_date"
    t.decimal "money_amount", precision: 10, scale: 2
    t.string "category"
    t.text "comment"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "groups", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.integer "kind", null: false
    t.integer "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_groups_on_event_id"
  end

  create_table "hostels", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "title"
    t.string "homepage"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mailinglists", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.integer "sender_group_id"
    t.integer "receiver_group_id"
    t.integer "moderator_group_id"
    t.string "public_email_address"
    t.boolean "can_unsubscribe"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["moderator_group_id"], name: "index_mailinglists_on_moderator_group_id"
    t.index ["receiver_group_id"], name: "index_mailinglists_on_receiver_group_id"
    t.index ["sender_group_id"], name: "index_mailinglists_on_sender_group_id"
  end

  create_table "member_subscriptions", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "mailinglist_id", null: false
    t.bigint "person_id", null: false
    t.boolean "as_sender", null: false
    t.boolean "as_receiver", null: false
    t.boolean "as_moderator", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mailinglist_id"], name: "index_member_subscriptions_on_mailinglist_id"
    t.index ["person_id"], name: "index_member_subscriptions_on_person_id"
  end

  create_table "payments", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "person_id"
    t.integer "payment_type"
    t.date "start"
    t.date "end"
    t.decimal "amount", precision: 10, scale: 2
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "transfer_date"
    t.index ["person_id"], name: "index_payments_on_person_id"
  end

  create_table "people", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "account_name"
    t.boolean "active"
    t.string "first_name"
    t.string "last_name"
    t.string "email_address"
    t.date "birthday"
    t.integer "gender"
    t.date "joined"
    t.date "quitted"
    t.date "paid_until"
    t.date "member_until"
    t.boolean "newsletter"
    t.boolean "photos_allowed"
    t.boolean "publish_birthday"
    t.boolean "publish_email"
    t.boolean "publish_address"
    t.boolean "publish"
    t.string "railway_station"
    t.string "railway_discount"
    t.string "meal_preference"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "crypted_password"
    t.string "salt"
    t.string "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.integer "access_count_to_reset_password_page", default: 0
    t.index ["account_name"], name: "index_people_on_account_name"
    t.index ["email_address"], name: "index_people_on_email_address"
    t.index ["reset_password_token"], name: "index_people_on_reset_password_token"
  end

  create_table "registration_payments", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "registration_id"
    t.date "money_transfer_date"
    t.decimal "money_amount", precision: 10, scale: 2
    t.text "comment"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "payment_type", default: 0
    t.string "category"
    t.index ["registration_id"], name: "index_registration_payments_on_registration_id"
  end

  create_table "registrations", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "event_id"
    t.integer "person_id"
    t.integer "status"
    t.boolean "organizer"
    t.boolean "member_discount"
    t.string "other_discounts"
    t.date "money_transfer_date"
    t.boolean "payment_complete"
    t.datetime "arrival"
    t.datetime "departure"
    t.integer "nights_stay"
    t.string "station_arrival"
    t.string "station_departure"
    t.string "railway_discount"
    t.string "meal_preference"
    t.text "talks"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_registrations_on_event_id"
    t.index ["person_id"], name: "index_registrations_on_person_id"
  end

  create_table "sepa_mandates", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "mandate_reference"
    t.date "signature_date"
    t.string "iban"
    t.string "bic"
    t.string "name_account_holder"
    t.integer "person_id"
    t.integer "sequence_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "sponsor_membership", precision: 10
    t.boolean "allow_all_payments", default: true
  end

  create_table "versions", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object", size: :long
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end


  create_view "active_affiliations", sql_definition: <<-SQL
      select `affiliations`.`group_id` AS `group_id`,`affiliations`.`groupable_type` AS `groupable_type`,`affiliations`.`groupable_id` AS `groupable_id` from `affiliations` where (`affiliations`.`start` is null or `affiliations`.`start` <= current_timestamp()) and (`affiliations`.`end` is null or `affiliations`.`end` >= current_timestamp())
  SQL
  create_view "recursive_subgroups", sql_definition: <<-SQL
      with recursive direct_subgroups(`group_id`,`child_id`) as (select `active_affiliations`.`group_id` AS `group_id`,`active_affiliations`.`groupable_id` AS `child_id` from `active_affiliations` where `active_affiliations`.`groupable_type` = 'Group'), recursive_subgroups_relation(`group_id`,`descendant_id`) as (select `groups`.`id` AS `group_id`,`groups`.`id` AS `descendant_id` from `groups` union select distinct `d`.`group_id` AS `group_id`,`r`.`descendant_id` AS `descendant_id` from (`direct_subgroups` `d` join `recursive_subgroups_relation` `r`) where `d`.`child_id` = `r`.`group_id`)select `recursive_subgroups_relation`.`group_id` AS `group_id`,`recursive_subgroups_relation`.`descendant_id` AS `descendant_id` from `recursive_subgroups_relation`
  SQL
  create_view "recursive_members", sql_definition: <<-SQL
      with recursive automatic_members(`group_id`,`person_id`) as (select `groups`.`id` AS `group_id`,`registrations`.`person_id` AS `person_id` from (`groups` join `registrations`) where `groups`.`event_id` = `registrations`.`event_id` and (`groups`.`kind` = 7 and `registrations`.`organizer` <> 0 or `groups`.`kind` = 8 and `registrations`.`status` in (1,2)) union select `groups`.`id` AS `id`,`people`.`id` AS `id` from (`groups` join `people`) where `groups`.`kind` = 4 and `people`.`active` <> 0 and current_timestamp() between `people`.`joined` and `people`.`member_until` or `groups`.`kind` = 5 and `people`.`active` <> 0 and (current_timestamp() not between `people`.`joined` and `people`.`member_until` or `people`.`joined` is null or `people`.`member_until` is null) or `groups`.`kind` = 6 and `people`.`active` <> 0 and `people`.`newsletter` <> 0), direct_members(`group_id`,`person_id`) as (select `active_affiliations`.`group_id` AS `group_id`,`active_affiliations`.`groupable_id` AS `person_id` from `active_affiliations` where `active_affiliations`.`groupable_type` = 'Person' union select `automatic_members`.`group_id` AS `group_id`,`automatic_members`.`person_id` AS `person_id` from `automatic_members`), recursive_members_relation(`group_id`,`person_id`) as (select distinct `r`.`group_id` AS `group_id`,`d`.`person_id` AS `person_id` from (`recursive_subgroups` `r` join `direct_members` `d`) where `d`.`group_id` = `r`.`descendant_id`)select `recursive_members_relation`.`group_id` AS `group_id`,`recursive_members_relation`.`person_id` AS `person_id` from `recursive_members_relation`
  SQL
  create_view "accounts", sql_definition: <<-SQL
      select `groups`.`title` AS `group_title`,`people`.`id` AS `account_id`,`people`.`account_name` AS `account_name`,`people`.`crypted_password` AS `crypted_password`,`people`.`email_address` AS `email_address` from ((`recursive_members` `m` join `groups`) join `people`) where `m`.`group_id` = `groups`.`id` and `m`.`person_id` = `people`.`id`
  SQL
  create_view "all_subscriptions", sql_definition: <<-SQL
      with senders(`mailinglist_id`,`email_address`,`first_name`,`last_name`) as (select `ml`.`id` AS `mailinglist_id`,`p`.`email_address` AS `email_address`,`p`.`first_name` AS `first_name`,`p`.`last_name` AS `last_name` from ((`recursive_members` `gp` join `mailinglists` `ml`) join `people` `p`) where `gp`.`person_id` = `p`.`id` and `gp`.`group_id` = `ml`.`sender_group_id`), receivers(`mailinglist_id`,`email_address`,`first_name`,`last_name`) as (select `ml`.`id` AS `mailinglist_id`,`p`.`email_address` AS `email_address`,`p`.`first_name` AS `first_name`,`p`.`last_name` AS `last_name` from ((`recursive_members` `gp` join `mailinglists` `ml`) join `people` `p`) where `gp`.`person_id` = `p`.`id` and `gp`.`group_id` = `ml`.`receiver_group_id`), moderators(`mailinglist_id`,`email_address`,`first_name`,`last_name`) as (select `ml`.`id` AS `mailinglist_id`,`p`.`email_address` AS `email_address`,`p`.`first_name` AS `first_name`,`p`.`last_name` AS `last_name` from ((`recursive_members` `gp` join `mailinglists` `ml`) join `people` `p`) where `gp`.`person_id` = `p`.`id` and `gp`.`group_id` = `ml`.`moderator_group_id`), automatic(`mailinglist_id`,`email_address`,`first_name`,`last_name`,`as_sender`,`as_receiver`,`as_moderator`) as (select `flag_table`.`mailinglist_id` AS `mailinglist_id`,`flag_table`.`email_address` AS `email_address`,`flag_table`.`first_name` AS `first_name`,`flag_table`.`last_name` AS `last_name`,max(`flag_table`.`as_sender`) = 1 AS `as_sender`,max(`flag_table`.`as_receiver`) = 1 AS `as_receiver`,max(`flag_table`.`as_moderator`) = 1 AS `as_moderator` from (select `senders`.`mailinglist_id` AS `mailinglist_id`,`senders`.`email_address` AS `email_address`,`senders`.`first_name` AS `first_name`,`senders`.`last_name` AS `last_name`,1 AS `as_sender`,0 AS `as_receiver`,0 AS `as_moderator` from `senders` union select `receivers`.`mailinglist_id` AS `mailinglist_id`,`receivers`.`email_address` AS `email_address`,`receivers`.`first_name` AS `first_name`,`receivers`.`last_name` AS `last_name`,0 AS `as_sender`,1 AS `as_receiver`,0 AS `as_moderator` from `receivers` union select `moderators`.`mailinglist_id` AS `mailinglist_id`,`moderators`.`email_address` AS `email_address`,`moderators`.`first_name` AS `first_name`,`moderators`.`last_name` AS `last_name`,0 AS `as_sender`,0 AS `as_receiver`,1 AS `as_moderator` from `moderators`) `flag_table` group by `flag_table`.`mailinglist_id`,`flag_table`.`email_address`), members(`mailinglist_id`,`email_address`,`first_name`,`last_name`,`as_sender`,`as_receiver`,`as_moderator`) as (select `mm`.`mailinglist_id` AS `mailinglist_id`,`p`.`email_address` AS `email_address`,`p`.`first_name` AS `first_name`,`p`.`last_name` AS `last_name`,`mm`.`as_sender` AS `as_sender`,`mm`.`as_receiver` AS `as_receiver`,`mm`.`as_moderator` AS `as_moderator` from (`member_subscriptions` `mm` join `people` `p`) where `mm`.`person_id` = `p`.`id`), manual(`mailinglist_id`,`email_address`,`first_name`,`last_name`,`as_sender`,`as_receiver`,`as_moderator`) as (select `email_subscriptions`.`mailinglist_id` AS `mailinglist_id`,`email_subscriptions`.`email_address` AS `email_address`,`email_subscriptions`.`first_name` AS `first_name`,`email_subscriptions`.`last_name` AS `last_name`,`email_subscriptions`.`as_sender` AS `as_sender`,`email_subscriptions`.`as_receiver` AS `as_receiver`,`email_subscriptions`.`as_moderator` AS `as_moderator` from `email_subscriptions`)select `combination_table`.`mailinglist_id` AS `mailinglist_id`,`combination_table`.`email_address` AS `email_address`,`combination_table`.`first_name` AS `first_name`,`combination_table`.`last_name` AS `last_name`,`combination_table`.`as_sender` AS `as_sender`,`combination_table`.`as_receiver` AS `as_receiver`,`combination_table`.`as_moderator` AS `as_moderator`,max(`combination_table`.`m`) AS `manual` from (select `manual`.`mailinglist_id` AS `mailinglist_id`,`manual`.`email_address` AS `email_address`,`manual`.`first_name` AS `first_name`,`manual`.`last_name` AS `last_name`,`manual`.`as_sender` AS `as_sender`,`manual`.`as_receiver` AS `as_receiver`,`manual`.`as_moderator` AS `as_moderator`,2 AS `m` from `manual` union select `members`.`mailinglist_id` AS `mailinglist_id`,`members`.`email_address` AS `email_address`,`members`.`first_name` AS `first_name`,`members`.`last_name` AS `last_name`,`members`.`as_sender` AS `as_sender`,`members`.`as_receiver` AS `as_receiver`,`members`.`as_moderator` AS `as_moderator`,1 AS `m` from `members` union select `automatic`.`mailinglist_id` AS `mailinglist_id`,`automatic`.`email_address` AS `email_address`,`automatic`.`first_name` AS `first_name`,`automatic`.`last_name` AS `last_name`,`automatic`.`as_sender` AS `as_sender`,`automatic`.`as_receiver` AS `as_receiver`,`automatic`.`as_moderator` AS `as_moderator`,0 AS `m` from `automatic`) `combination_table` group by `combination_table`.`mailinglist_id`,`combination_table`.`email_address`
  SQL
end
