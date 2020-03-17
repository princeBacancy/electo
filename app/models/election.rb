# frozen_string_literal: true

# manages elections
class Election < ApplicationRecord
  # callbacks
  after_create :election_confirmation_mail

  # relations
  belongs_to :admin, class_name: 'User', foreign_key: 'admin_id'
  has_many :election_data, dependent: :destroy
  has_many :winners, dependent: :destroy
  has_many :requests, dependent: :destroy
  has_many :pending_voters, dependent: :destroy
  has_many :voters, class_name: 'VotingList', foreign_key: 'election_id',
                    dependent: :destroy
  has_many :payments
  
  # enums & scopes
  enum status: %i[live waiting suspended]
  enum approval_status: %i[pending approved rejected]
  scope :order_by_status, -> { order(:status) }

  #validations
  validates :title, uniqueness: true
  validates_presence_of :admin_id, :title, :description,
                        :deadline_for_registration,
                        :start_time,
                        :end_time
  

  def election_confirmation_mail
    ConfirmElectionMailer.confirmation(self).deliver
  end

  def self.piechart_data(election)
    election.election_data.joins(:candidate).pluck(:user_name, :votes_count)
  end

  #schedular
  def self.trigger
    puts 'in trigger'
    elections = Election.includes(:requests).where(approval_status: approved)
    elections.each do |election|
      puts 'in each loop'
      start_time = election.start_time.strftime('%d %b %Y %H:%M')
      end_time = election.end_time.strftime('%d %b %Y %H:%M')
      if start_time == DateTime.now.strftime('%d %b %Y %H:%M')
        puts 'in if'
        if election.update(status: 'live')
          voters = election.requests.where(status: :approved)
          voters.each do |voter|
            ElectionLiveNotificationMailer.notify(voter, election).deliver
          end
        end
      elsif end_time == DateTime.now.strftime('%d %b %Y %H:%M')
        puts 'in elsif'
        election.update(status: 'suspended')
      end
    end
  end
end
