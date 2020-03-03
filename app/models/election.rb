# frozen_string_literal: true

class Election < ApplicationRecord
  belongs_to :admin, class_name: 'User', foreign_key: 'admin_id'
  has_many :election_data, dependent: :destroy
  has_one :winner
  has_many :requests
  has_many :pending_voters, dependent: :destroy
  has_many :voters, class_name: 'VotingList', foreign_key: 'election_id'

  def self.trigger
    puts "in trigger"
    @elections = Election.where(approval_status: true)
    @elections.each do |election|
      puts "in each loop"
      start_time = election.start_time.strftime('%d %b %Y %H:%M')
      end_time = election.end_time.strftime('%d %b %Y %H:%M')
      if start_time == DateTime.now.strftime('%d %b %Y %H:%M')
        puts "in if"
        election.update(status: true)
      elsif end_time == DateTime.now.strftime('%d %b %Y %H:%M')
        puts "in elsif"
        election.update(status: false,approval_status: false)
      end
    end
  end
end