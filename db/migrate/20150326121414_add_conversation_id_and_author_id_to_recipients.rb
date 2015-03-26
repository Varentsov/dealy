class AddConversationIdAndAuthorIdToRecipients < ActiveRecord::Migration
  def change
    add_reference :recipients, :conversation, index: true
    add_foreign_key :recipients, :conversations
    add_reference :recipients, :author, index: true
  end
end
