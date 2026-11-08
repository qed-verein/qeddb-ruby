class AddUniquenessConstraints < ActiveRecord::Migration[6.1]
  def change
    add_index :groups, :title, unique: true
    remove_index :people, :account_name # Exists without uniqueness constraint
    add_index :people, :account_name, unique: true
    add_index :registrations, [:person_id, :event_id], unique: true
  end
end
