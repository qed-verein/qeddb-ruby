class AddTypeAndCategoryToRegistrationPayments < ActiveRecord::Migration[6.1]
  def change
    add_column :registration_payments, :payment_type, :integer, default: 0
    add_column :registration_payments, :category, :string
  end
end
