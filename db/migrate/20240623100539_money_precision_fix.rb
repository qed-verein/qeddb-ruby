class MoneyPrecisionFix < ActiveRecord::Migration[6.1]
  def change
    change_column :registrations, :money_amount, :decimal, :precision => 2
    change_column :payments, :amount, :decimal, :precision => 2
  end
end
