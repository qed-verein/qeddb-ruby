class CreateSepaMandates < ActiveRecord::Migration[6.1]
  def change
    create_table :sepa_mandates do |t|
      t.string :mandate_reference
      t.date :signature_date
      t.string :iban
      t.string :bic
      t.string :name_account_holder
      t.integer :person_id

      t.timestamps
    end
  end
end
