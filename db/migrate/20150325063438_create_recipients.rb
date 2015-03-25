class CreateRecipients < ActiveRecord::Migration
  def change
    create_table :recipients do |t|
      t.belongs_to :user, index: true
      t.belongs_to :message, index: true
      t.boolean :inbox, default: true
      t.boolean :read, default: false
      t.boolean :deleted, defauld: false

      t.timestamps null: false
    end
    add_foreign_key :recipients, :users
    add_foreign_key :recipients, :messages
  end
end
