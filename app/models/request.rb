# frozen_string_literal: true

# manages all requestes for elections
class Request < ApplicationRecord
  # callbacks
  after_create :request_confirmation_mail

  # relations
  belongs_to :request_sender, class_name: 'User',
                              foreign_key: 'request_sender_id'
  belongs_to :election

  # enum  & scope
  enum status: %i[pending approved rejected]

  # validations
  validates_presence_of :request_sender_id, :election_id, :purpose
  validates :request_sender_id, uniqueness: { scope: %i[election_id purpose] }

  def self.get_request(current_user, params)
    Request.includes(:election).find_by(election_id: params[:id],
                                        request_sender_id: current_user.id,
                                        purpose: params[:type])
  end

  def self.create_request(current_user, params)
    new(election_id: params[:id], request_sender_id: current_user.id,
        purpose: params[:type])
  end

  def self.time_out?(request)
    request.election.deadline_for_registration > DateTime.now
  end

  def request_confirmation_mail
    RequestConfirmMailer.request_confirm(self).deliver
  end

  def self.broadcast(notification)
    # ActionCable.server.broadcast('notification_channel',
    #                              notification: notification)
  end

  def self.import(file, election_id)
    election = Election.includes(:requests, :pending_voters).find(election_id)
    CSV.foreach(file.path, headers: true) do |row|
      email = row.to_hash['email']
      user = User.find_by(email: email)
      pending_voter = election.pending_voters.find_by(email: email)

      if user
        request = election.requests.find_by(request_sender_id: user.id,
                                            purpose: 'voter')
      end
      if user && !request
        election.requests.build(request_sender_id: user.id,
                                purpose: 'voter', status: :approved).save
      end
      VotingPermissionMailer.voting_permission(email, election_id).deliver
      if !user && !pending_voter
        election.pending_voters.build(email: email).save
      end
    end
  end
end
