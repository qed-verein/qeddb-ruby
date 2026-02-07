class CreateGenericPayments < ActiveRecord::Migration[6.1]
  def change
    create_table :generic_payments do |t|
      t.string :counterparty
      t.date :money_transfer_date
      t.decimal :money_amount, precision: 10, scale: 2 
      t.string :category
      t.text :comment

      t.timestamps
    end
  end
end
