module NotificationsHelper
  def notifications_counter
    Notification.where(employee_id: current_user.employee_ids).hasnt_read.count
  end
end
