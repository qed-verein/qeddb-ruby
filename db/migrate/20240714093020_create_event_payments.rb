class CreateEventPayments < ActiveRecord::Migration[6.1]
  def change
    create_table :event_payments do |t|
      t.belongs_to :event
      t.date "money_transfer_date"
      t.decimal "money_amount", :precision => 10, :scale => 2
      t.string "category"
      t.text "comment"

      t.timestamps
    end
  end
end
