class Request < ApplicationRecord
  belongs_to :request_sender, class_name: "User", foreign_key: "request_sender_id"
  belongs_to :request_receiver, class_name: "User", foreign_key: "request_receiver_id"
  belongs_to :election

  def self.import(file,election_id)
    election = Election.find(election_id)
    CSV.foreach(file.path, headers: true) do |row|
      email = row.to_hash["email"]
      user = User.find_by(email: email)
      panding_voter = PandingVoter.find_by(election_id: election.id, email: email)
      
      request = Request.find_by(request_sender_id: user.id, request_receiver_id: election.admin.id, election_id: election.id, purpose: "voter") if user
      byebug
      if user and !request
        Request.create(request_sender_id: user.id, request_receiver_id: election.admin.id, election_id: election.id, purpose: "voter", status: true)
      elsif !user and !panding_voter
        PandingVoter.create(election_id: election.id, email: email)
      end
    end
  end
end
