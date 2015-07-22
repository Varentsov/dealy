class CreateEmployeeRoles < ActiveRecord::Migration
  def change
    create_table :employee_roles do |t|
      t.references :employee, index: true, foreign_key: true
      t.references :role, index: true, foreign_key: true
    end
  end
end
