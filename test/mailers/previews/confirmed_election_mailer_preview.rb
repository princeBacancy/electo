# Preview all emails at http://localhost:3000/rails/mailers/confirmed_election_mailer
class ConfirmedElectionMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/confirmed_election_mailer/confirmed
  def confirmed
    ConfirmedElectionMailer.confirmed
  end

end
