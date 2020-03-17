module NotificationsHelper
  def get_notifications
    @notifications = Notification.unread_notifications(current_user.id)
  end
end
