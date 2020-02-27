class RequestConfirmedMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.request_confirmed_mailer.request_confirmed.subject
  #
  def request_confirmed(request)
    @greeting = "Hi"
    @request = request
    mail to: request.request_sender.email, subject: "Request Approved"
  end
end
