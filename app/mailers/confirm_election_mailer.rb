# frozen_string_literal: true

# a request for approval of election is send to super admin
class ConfirmElectionMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.confirm_election_mailer.confirmation.subject
  #
  def confirmation(election)
    @greeting = 'Hi'
    @election = election
    @admin = election.admin
    mail to: 'princerabadiya@bacancytechnology.com',
         subject: 'Election Creation Confirmation'
  end
end
