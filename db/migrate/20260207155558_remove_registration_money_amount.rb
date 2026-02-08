class RemoveRegistrationMoneyAmount < ActiveRecord::Migration[6.1]
  def change
    up_only do
      # setting money_amount to NULL is a deprecated way of indicating a completed payment
      # these registrations will be migrated to payment_complete
      result = select_all <<-SQL
        SELECT COUNT(*) AS count
        FROM registrations
        JOIN events ON events.id = registrations.event_id
        WHERE events.end > '2021-12-31' AND registrations.money_amount IS NULL
      SQL
      raise ActiveRecord::MigrationError if result[0]['count'] != 0

      # setting status to confirmed (2) is a deprecated way of indicating a completed payment
      # there should not be any such data anymore
      result = select_all <<-SQL
        SELECT COUNT(*) as count
        FROM registrations
        WHERE NOT payment_complete AND status = 2 AND money_amount IS NOT NULL AND money_amount <> 0
          AND NOT EXISTS (SELECT * FROM registration_payments WHERE registration_payments.registration_id = registrations.id)
      SQL
      raise ActiveRecord::MigrationError if result[0]['count'] != 0

      # mark old payments as completed
      execute <<-SQL
        UPDATE registrations
        SET payment_complete = TRUE
        WHERE money_amount IS NULL  
      SQL

      # migrate deviations between registration.money_amount and event.cost to a charge_modifier
      execute <<-SQL
        INSERT INTO charge_modifiers(registration_id, money_amount, reason, created_at, updated_at)
        SELECT registrations.id, (registrations.money_amount - events.cost), 'unbekannt', current_timestamp, current_timestamp
        FROM registrations
        JOIN events ON events.id = registrations.event_id
        WHERE registrations.money_amount <> events.cost
      SQL
    end

    remove_column :registrations, :money_amount
  end
end
