# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/election_live_notification_mailer
class ElectionLiveNotificationMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/election_live_notification_mailer/notify
  def notify
    ElectionLiveNotificationMailer.notify
  end
end
