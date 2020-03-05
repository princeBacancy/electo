
# frozen_string_literal: true

class Request < ApplicationRecord
  belongs_to :request_sender, class_name: 'User', foreign_key: 'request_sender_id'
  belongs_to :request_receiver, class_name: 'User', foreign_key: 'request_receiver_id'
  belongs_to :election
  enum status: %i[pending approved rejected]

  def self.import(file, election_id)
    election = Election.find(election_id)
    CSV.foreach(file.path, headers: true) do |row|
      email = row.to_hash['email']
      user = User.find_by(email: email)
      pending_voter = PendingVoter.find_by(election_id: election.id, email: email)

      if user
        request = Request.find_by(request_sender_id: user.id, request_receiver_id: election.admin.id,
                                  election_id: election.id, purpose: 'voter')
      end
      
      if user && !request
        request = Request.new(request_sender_id: user.id, request_receiver_id: election.admin.id,
                              election_id: election.id, purpose: 'voter', status: :approved)
        request.save
        VotingPermissionMailer.voting_permission(request).deliver
      elsif !user && !pending_voter
        NonUserEmailDeliveryMailer.email_delivery(email,election_id).deliver
        PendingVoter.create(election_id: election.id, email: email)
      end
    end
  end

end
