class AddStateToEmployeeTasks < ActiveRecord::Migration
  def change
    add_column :employee_tasks, :state, :integer, default: 0
  end
end
