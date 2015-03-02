class AddTimeStatesToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :planning_state, :integer, default: 0
  end
end
