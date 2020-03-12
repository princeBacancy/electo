# frozen_string_literal: true

# sending confirmation request to election admin
class RequestConfirmMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.request_confirm_mailer.request_confirm.subject
  #
  def request_confirm(request)
    @greeting = 'Hi'
    @request = request
    @election = request.election
    @request_sender = request.request_sender
    mail to: request.election.admin.email, subject: 'Request Confirmation'
  end
end
