class AddDefaultFalseDeletedToRecipients < ActiveRecord::Migration
  def self.up
    change_column_default :recipients, :deleted, false
    Recipient.where(:deleted => nil).update_all(:deleted => false)
  end

  def self.down
    change_column_default :recipients, :deleted, nil
  end
end
