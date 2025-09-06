# frozen_string_literal: true

class CreateChargeModifiers < ActiveRecord::Migration[6.1]
  def change
    create_table :charge_modifiers do |t|
      t.belongs_to :registration
      t.decimal 'money_amount', precision: 10, scale: 2
      t.string 'reason'
      t.text 'comment'

      t.timestamps
    end
  end
end
