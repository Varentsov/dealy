class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.datetime :deadline
      t.boolean :fire, null: false, default: false

      t.timestamps null: false
    end
  end
end
