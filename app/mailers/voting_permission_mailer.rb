# frozen_string_literal: true

# assigning permission to voters by election admin
class VotingPermissionMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.voting_permission_mailer.voting_permission.subject
  #
  def voting_permission(email, election_id)
    @greeting = 'Hi'
    @election = Election.includes(:admin).find(election_id)
    mail to: email, subject: 'permission to vote'
  end
end
