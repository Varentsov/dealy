class CreateProposals < ActiveRecord::Migration
  def change
    create_table :proposals do |t|
      t.belongs_to :task, index: true, foreign_key: true
      t.belongs_to :supplier, index: true, foreign_key: true
      t.belongs_to :receiver, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
