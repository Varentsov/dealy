class AddFinishedAndFinishTimeToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :finished, :boolean, null: false, default: false
    add_column :tasks, :finish_time, :datetime
  end
end
