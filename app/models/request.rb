class Request < ApplicationRecord
  belongs_to :request_sender, class_name: "User", foreign_key: "request_sender_id"
  belongs_to :request_receiver, class_name: "User", foreign_key: "request_receiver_id"
  belongs_to :election

  def self.import(file,election_id)
    election = Election.find(election_id)
    CSV.foreach(file.path, headers: true) do |row|
      email = row.to_hash["email"]
      user = User.find_by(email: email)
      pending_voter = PendingVoter.find_by(election_id: election.id, email: email)
      
      request = Request.find_by(request_sender_id: user.id, request_receiver_id: election.admin.id, election_id: election.id, purpose: "voter") if user
      
      if user and !request
        request = Request.new(request_sender_id: user.id, request_receiver_id: election.admin.id, election_id: election.id, purpose: "voter", status: true)
        request.save
        VotingPermissionMailer.voting_permission(request).deliver
      elsif !user and !pending_voter
        PendingVoter.create(election_id: election.id, email: email)
      end
    end
  end
end
