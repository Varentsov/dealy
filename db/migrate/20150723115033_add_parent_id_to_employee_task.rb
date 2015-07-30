class AddParentIdToEmployeeTask < ActiveRecord::Migration
  def change
    add_column :employee_tasks, :parent_id, :integer
  end
end
