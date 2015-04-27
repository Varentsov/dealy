module ConversationsHelper
  def unread_messages_count
    current_user.recipients.where(:read => false).count
  end
end
