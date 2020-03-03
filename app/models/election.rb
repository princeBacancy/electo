# frozen_string_literal: true

class Election < ApplicationRecord
  belongs_to :admin, class_name: 'User', foreign_key: 'admin_id'
  has_many :election_data, dependent: :destroy
  has_one :winner
  has_many :requests
  has_many :pending_voters, dependent: :destroy
  has_many :voters, class_name: 'VotingList', foreign_key: 'election_id'

  def self.trigger
    @elections = Election.where(approval_status: 1)
    @elections.each do |election|
      if election.start_time == DateTime.now
        election.update(status: true)
      elsif election.end_time == DateTime.now
        election.update(status: false)
      end
    end
  end
end