class AddIsGroupToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :is_group, :boolean, default: false
  end
end
