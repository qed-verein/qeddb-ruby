class RefactorGroupTypes < ActiveRecord::Migration[6.1]
  def change
    rename_column :groups, :program, :kind
    change_column_null :groups, :kind, false, 0
    remove_column :groups, :mode, :integer
    update_view :recursive_members, version: 3, revert_to_version: 2
  end
end
