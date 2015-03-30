class CreateWorkspaces < ActiveRecord::Migration
  def change
    create_table :workspaces do |t|
      t.string :name, default: ''
      t.belongs_to :group, index: true
      t.belongs_to :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :workspaces, :groups
    add_foreign_key :workspaces, :users
  end
end
