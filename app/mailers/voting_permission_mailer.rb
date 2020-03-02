# frozen_string_literal: true

class VotingPermissionMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.voting_permission_mailer.voting_permission.subject
  #
  def voting_permission(request)
    @greeting = 'Hi'
    @request = request
    mail to: request.request_sender.email, subject: 'permission to vote'
  end
end
