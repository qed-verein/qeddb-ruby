class CreateRegistrationPayments < ActiveRecord::Migration[6.1]
  def change
    create_table :registration_payments do |t|
      t.belongs_to :registration
      t.date 'money_transfer_date'
      t.decimal 'money_amount', precision: 10, scale: 2
      t.text 'comment'

      t.timestamps
    end
  end
end
