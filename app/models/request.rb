
# frozen_string_literal: true

class Request < ApplicationRecord
  belongs_to :request_sender, class_name: 'User', foreign_key: 'request_sender_id'
  belongs_to :election
  enum status: %i[pending approved rejected]
  
  def self.import(file, election_id)
    election = Election.includes(:requests, :pending_voters).find(election_id)
    CSV.foreach(file.path, headers: true) do |row|
      email = row.to_hash['email']
      user = User.find_by(email: email)
      pending_voter = election.pending_voters.find_by(email: email)

      if user
        request = election.requests.find_by(request_sender_id: user.id, purpose: 'voter')
      end
      
      if user && !request
        request = election.requests.build(request_sender_id: user.id, purpose: 'voter', status: :approved)
        if request.save
          VotingPermissionMailer.voting_permission(request).deliver
        end
      elsif !user && !pending_voter
        NonUserEmailDeliveryMailer.email_delivery(email,election_id).deliver
        election.pending_voters.build(email: email).save
      end
    end
  end

end
