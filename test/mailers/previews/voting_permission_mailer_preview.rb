# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/voting_permission_mailer
class VotingPermissionMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/voting_permission_mailer/voting_permission
  def voting_permission
    VotingPermissionMailer.voting_permission
  end
end
