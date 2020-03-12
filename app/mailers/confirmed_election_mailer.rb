# frozen_string_literal: true

# reverting to election creator that election is approved by super admin
class ConfirmedElectionMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.confirmed_election_mailer.confirmed.subject
  #
  def confirmed(election)
    @greeting = 'Hi'
    @election = election
    @admin_email = @election.admin.email
    mail to: @admin_email, subject: 'Request Confirmed!!!'
  end
end
