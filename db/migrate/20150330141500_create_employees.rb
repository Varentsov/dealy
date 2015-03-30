class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.belongs_to :user, index: true
      t.belongs_to :group, index: true

      t.timestamps null: false
    end
    add_foreign_key :employees, :users
    add_foreign_key :employees, :groups
  end
end
