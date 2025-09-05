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

ActiveRecord::Schema.define(version: 2024_10_01_220224) do

  create_table "addresses", force: :cascade do |t|
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

  create_table "affiliations", force: :cascade do |t|
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

  create_table "contacts", force: :cascade do |t|
    t.integer "person_id"
    t.string "protocol"
    t.string "identifier"
    t.integer "priority"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_contacts_on_person_id"
  end

  create_table "event_payments", force: :cascade do |t|
    t.integer "event_id"
    t.date "money_transfer_date"
    t.decimal "money_amount", precision: 10, scale: 2
    t.string "category"
    t.text "comment"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["event_id"], name: "index_event_payments_on_event_id"
  end

  create_table "events", force: :cascade do |t|
    t.integer "hostel_id"
    t.string "title"
    t.string "homepage"
    t.date "start"
    t.date "end"
    t.date "deadline"
    t.string "cost"
    t.integer "max_participants"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reference_line"
    t.index ["hostel_id"], name: "index_events_on_hostel_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.integer "mode"
    t.integer "program"
    t.integer "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_groups_on_event_id"
  end

  create_table "hostels", force: :cascade do |t|
    t.string "title"
    t.string "homepage"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mailinglists", force: :cascade do |t|
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

  create_table "payments", force: :cascade do |t|
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

  create_table "people", force: :cascade do |t|
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

  create_table "registration_payments", force: :cascade do |t|
    t.integer "registration_id"
    t.date "money_transfer_date"
    t.decimal "money_amount", precision: 10, scale: 2
    t.text "comment"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "payment_type", default: 0
    t.string "category"
    t.index ["registration_id"], name: "index_registration_payments_on_registration_id"
  end

  create_table "registrations", force: :cascade do |t|
    t.integer "event_id"
    t.integer "person_id"
    t.integer "status"
    t.boolean "organizer"
    t.boolean "member_discount"
    t.string "other_discounts"
    t.date "money_transfer_date"
    t.decimal "money_amount", precision: 10, scale: 2
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

  create_table "sepa_mandates", force: :cascade do |t|
    t.string "mandate_reference"
    t.date "signature_date"
    t.string "iban"
    t.string "bic"
    t.string "name_account_holder"
    t.integer "person_id"
    t.integer "sequence_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "sponsor_membership"
    t.boolean "allow_all_payments", default: true
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer "mailinglist_id"
    t.string "first_name"
    t.string "last_name"
    t.string "email_address"
    t.boolean "as_sender"
    t.boolean "as_receiver"
    t.boolean "as_moderator"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mailinglist_id"], name: "index_subscriptions_on_mailinglist_id"
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object", limit: 1073741823
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end


  create_view "active_affiliations", sql_definition: <<-SQL
    		-- Liefert die Liste aller momentan gültigen Gruppenzugehörigkeiten
		SELECT group_id, groupable_type, groupable_id
		FROM affiliations
		WHERE (start IS NULL OR start <= DATETIME('now'))
			AND (end IS NULL OR end >= DATETIME('now'))
  SQL
  create_view "recursive_subgroups", sql_definition: <<-SQL
    		/* Erzeugt eine SQL-View, welche für jede Gruppe alle hinzugefügten Untergruppen
		zurückliefert. Dabei werden auch mehrfach ineinander geschachtelte Gruppen berücksichtigt. */
		WITH RECURSIVE
		-- Liste der direkt eingetragen Untergruppen
		direct_subgroups(group_id, child_id) AS (
			SELECT group_id, groupable_id FROM active_affiliations
			WHERE groupable_type = 'Group'),
		-- Liste aller enthaltenen Untergruppen (auch rekursiv geschachtelt)
		recursive_subgroups_relation(group_id, descendant_id) AS (
			SELECT id, id FROM groups
			UNION
			SELECT DISTINCT d.group_id, r.descendant_id
			FROM direct_subgroups AS d, recursive_subgroups_relation AS r
			WHERE d.child_id = r.group_id)
		SELECT * FROM recursive_subgroups_relation
  SQL
  create_view "recursive_members", sql_definition: <<-SQL
      /* Erzeugt eine SQL-View, welche für jede Gruppe alle darin enthaltenen Personen zurückliefert.
     Dabei werden auch automatisch verwaltete Gruppen sowie  rekursive Beziehungen von
     verschachtelten Gruppen berücksichtigt */
  WITH RECURSIVE
  -- Liste der automatisch eingetragenen Gruppenmitglieder
  automatic_members(group_id, person_id) AS (
  	SELECT groups.id, registrations.person_id
  	FROM groups, registrations
  	WHERE groups.event_id = registrations.event_id AND
  		((groups.program = 7 AND registrations.organizer) OR
  		 (groups.program = 8 AND registrations.status IN (1, 2)))
  	UNION
  	SELECT groups.id, people.id
  	FROM groups, people
  	WHERE (groups.program = 4 AND people.active AND (DATETIME('now') BETWEEN people.joined AND people.member_until)) OR
  		  (groups.program = 5 AND people.active AND (NOT DATETIME('now') BETWEEN people.joined AND people.member_until OR
  				people.joined IS NULL OR people.member_until IS NULL)) OR
  		  (groups.program = 6 AND people.active AND people.newsletter)),
  -- Liste der manuell eingetragenen Gruppenmitglieder
  direct_members(group_id, person_id) AS (
  	SELECT group_id, groupable_id FROM active_affiliations
  	WHERE groupable_type = 'Person'
  	UNION
  	SELECT * FROM automatic_members),
  -- Liste aller momentanen Mitgleider einer Gruppe (auch rekursiv durch Untergruppen)
  recursive_members_relation(group_id, person_id) AS (
  	SELECT DISTINCT r.group_id, d.person_id
  	FROM recursive_subgroups AS r, direct_members AS d
  	WHERE d.group_id = r.descendant_id)
  SELECT * FROM recursive_members_relation
  SQL
  create_view "accounts", sql_definition: <<-SQL
    		/* Erzeugt eine SQL-View, welche für jede Berechtigunsgruppe
		wie Homepage, Gallery eine Liste aller Accounts liefert */
		SELECT
			groups.title AS group_title,
			people.id AS account_id,
			people.account_name AS account_name,
			people.crypted_password AS crypted_password,
			people.email_address AS email_address
		FROM recursive_members AS m, groups, people
		WHERE m.group_id = groups.id AND m.person_id = people.id
  SQL
  create_view "all_subscriptions", sql_definition: <<-SQL
    		/* Erzeugt eine SQL-View, welche für jede Emailverteiler
		eine Liste aller eingetragenen Emailadressen mit zugehörigen Rechten liefert.
		Dabei werden auch automatische eingetragenen Emailadressen beachtet. */
		WITH
		-- Sendergruppe einer Mailingliste
		senders(mailinglist_id, email_address, first_name, last_name) AS (
			SELECT ml.id, p.email_address, p.first_name, p.last_name
			FROM recursive_members AS gp, mailinglists AS ml, people AS p
			WHERE gp.person_id = p.id AND gp.group_id = ml.sender_group_id),
		-- Empfängergruppe einer Mailingliste
		receivers(mailinglist_id, email_address, first_name, last_name) AS (
			SELECT ml.id, p.email_address, p.first_name, p.last_name
			FROM recursive_members AS gp, mailinglists AS ml, people AS p
			WHERE gp.person_id = p.id AND gp.group_id = ml.receiver_group_id),
		-- Moderatorengruppe einer Mailingliste
		moderators(mailinglist_id, email_address, first_name, last_name) AS (
			SELECT ml.id, p.email_address, p.first_name, p.last_name
			FROM recursive_members AS gp, mailinglists AS ml, people AS p
			WHERE gp.person_id = p.id AND gp.group_id = ml.moderator_group_id),
		-- Alle über Gruppen automatisch eintragenen Sender, Empfänger und Moderatoren
		automatic(mailinglist_id, email_address, first_name, last_name, as_sender, as_receiver, as_moderator) AS (
			SELECT mailinglist_id, email_address, first_name, last_name, MAX(as_sender) = 1, MAX(as_receiver) = 1, MAX(as_moderator) = 1 FROM (
				SELECT *, 1 AS as_sender, 0 AS as_receiver, 0 AS as_moderator FROM senders UNION
				SELECT *, 0 AS as_sender, 1 AS as_receiver, 0 AS as_moderator FROM receivers UNION
				SELECT *, 0 AS as_sender, 0 AS as_receiver, 1 AS as_moderator FROM moderators) AS flag_table
			GROUP BY mailinglist_id, email_address),
		-- Manuelle Änderungen an der Mailingliste
		manual(mailinglist_id, email_address, first_name, last_name, as_sender, as_receiver, as_moderator) AS (
			SELECT mailinglist_id, email_address, first_name, last_name, as_sender, as_receiver, as_moderator
			FROM subscriptions)
		SELECT mailinglist_id, email_address, first_name, last_name, as_sender, as_receiver, as_moderator, MAX(m) AS manual
		FROM (
			SELECT *, TRUE AS m FROM manual UNION
			SELECT *, FALSE AS m FROM automatic) AS combination_table
		GROUP BY mailinglist_id, email_address
  SQL
end
