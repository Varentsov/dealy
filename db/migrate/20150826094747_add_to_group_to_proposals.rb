class AddToGroupToProposals < ActiveRecord::Migration
  def change
    add_column :proposals, :to_group, :boolean, default: :false
  end
end
