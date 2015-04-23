class CreateEmployeeTasks < ActiveRecord::Migration
  def change
    create_table :employee_tasks do |t|
      t.belongs_to :employee, index: true, foreign_key: true
      t.belongs_to :task, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
