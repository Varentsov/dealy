class AddHasReadToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :has_read, :boolean, default: false
  end
end
