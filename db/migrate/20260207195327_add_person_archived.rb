class AddPersonArchived < ActiveRecord::Migration[6.1]
  def change
    add_column :people, :archived, :boolean, default: false
  end
end
