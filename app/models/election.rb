# frozen_string_literal: true

class Election < ApplicationRecord
  belongs_to :admin, class_name: 'User', foreign_key: 'admin_id'
  has_many :election_data, dependent: :destroy
  has_many :winners, dependent: :destroy
  has_many :requests, dependent: :destroy
  has_many :pending_voters, dependent: :destroy
  has_many :voters, class_name: 'VotingList', foreign_key: 'election_id', dependent: :destroy
  enum status: %i[waiting live suspended] 
  enum approval_status: %i[pending approved rejected]

  def self.trigger
    puts "in trigger"
    @elections = Election.includes(:requests).where(approval_status: approved)
    @elections.each do |election|
      puts "in each loop"
      start_time = election.start_time.strftime('%d %b %Y %H:%M')
      end_time = election.end_time.strftime('%d %b %Y %H:%M')
      if start_time == DateTime.now.strftime('%d %b %Y %H:%M')
        puts "in if"
        if election.update(status: "live")
          @voters = election.requests.where(status: :approved)
          @voters.each do |voter|
          ElectionLiveNotificationMailer.notify(voter, election).deliver
          end
        end
      elsif end_time == DateTime.now.strftime('%d %b %Y %H:%M')
        puts "in elsif"
        election.update(status: "suspended")
      end
    end
  end
end

