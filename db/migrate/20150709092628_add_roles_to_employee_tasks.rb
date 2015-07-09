class AddRolesToEmployeeTasks < ActiveRecord::Migration
  def change
    add_column :employee_tasks, :role, :integer, default: 0
  end
end
