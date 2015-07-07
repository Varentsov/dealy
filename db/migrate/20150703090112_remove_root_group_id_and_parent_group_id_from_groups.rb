class RemoveRootGroupIdAndParentGroupIdFromGroups < ActiveRecord::Migration
  def change
    remove_column :groups, :root_id, :integer
    remove_column :groups, :parent_id, :integer
  end
end
