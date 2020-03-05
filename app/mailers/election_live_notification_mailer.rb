class ElectionLiveNotificationMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.election_live_notification_mailer.notify.subject
  #
  def notify(voter, election)
    @greeting = "Hi"
    @election = election
    email = voter.request_sender.email
    mail to: email, subject: "notification"
  end
end
