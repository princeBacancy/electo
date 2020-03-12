# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/confirm_election_mailer
class ConfirmElectionMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/confirm_election_mailer/confirmation
  def confirmation
    ConfirmElectionMailer.confirmation
  end
end
