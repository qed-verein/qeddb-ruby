class ViewCurrentTimestamp < ActiveRecord::Migration[6.1]
  def change
    update_view :active_affiliations, version: 2, revert_to_version: 1
    update_view :recursive_members, version: 2, revert_to_version: 1
  end
end
