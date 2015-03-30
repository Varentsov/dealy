class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.belongs_to :account, index: true
      t.belongs_to :root, index: true
      t.belongs_to :parent, index: true
      t.integer :account_state, default: 0
      t.string :ancestry, index: true

      t.timestamps null: false
    end
  end
end
