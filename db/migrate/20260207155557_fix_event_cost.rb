class FixEventCost < ActiveRecord::Migration[6.1]
  def change
    change_column :events, :cost, :decimal, precision: 10, scale: 2
  end
end
