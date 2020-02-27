class ConfirmElectionMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.confirm_election_mailer.confirmation.subject
  #
  def confirmation(election)
    @greeting = "Hi"
    @election = election
    mail to: "princerabadiya@bacancytechnology.com", subject: "Election Creation Confirmation" 
  end
end
