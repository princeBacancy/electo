class RequestConfirmMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.request_confirm_mailer.request_confirm.subject
  #
  def request_confirm(request)
    @greeting = "Hi"
    @request = request
    mail to: request.request_receiver.email, subject: "Request Confirmation"
  end
end
