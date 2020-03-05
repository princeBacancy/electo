# frozen_string_literal: true

class User < ApplicationRecord
  rolify
  # after_create :assign_default_role

  # def assign_default_role
  #   self.add_role("user")
  # end

  has_many :elections, class_name: 'Election', foreign_key: 'admin_id'
  has_many :election_data, class_name: 'ElectionDatum', foreign_key: 'candidate_id'

  has_many :votes, class_name: 'VoterList', foreign_key: 'voter_id'

  has_many :send_requests, class_name: 'Request', foreign_key: 'request_sender_id'
  has_many :received_requests, class_name: 'Request', foreign_key: 'request_receiver_id'

  has_many :send_messages, class_name: 'Message', foreign_key: 'message_sender_id'
  has_many :received_messages, class_name: 'Message', foreign_key: 'message_receiver_id'

  # Include default devise modules. Others available are:
  # , :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  validates :user_name, presence: true, uniqueness: true
end