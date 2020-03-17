class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def mark_as_read
    # current_user.notifications.update_all()
    Notification.read_notifications(current_user.id)

  end
end
