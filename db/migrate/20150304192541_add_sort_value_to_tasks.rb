class AddSortValueToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :sort_value, :integer, default: nil
  end
end
