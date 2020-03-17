# frozen_string_literal: true

# user model
class User < ApplicationRecord
  rolify
  # after_create :assign_default_role

  # def assign_default_role
  #   self.add_role("user")
  # end

  # relations
  has_many :elections, class_name: 'Election', foreign_key: 'admin_id'
  has_many :election_data, class_name: 'ElectionDatum',
                           foreign_key: 'candidate_id'
  has_many :votes, class_name: 'VotingList', foreign_key: 'voter_id'
  has_many :send_requests, class_name: 'Request',
                           foreign_key: 'request_sender_id'
  has_many :received_requests, class_name: 'Request',
                               foreign_key: 'request_receiver_id'
  has_many :send_messages, class_name: 'Message',
                           foreign_key: 'message_sender_id'
  has_many :received_messages, class_name: 'Message',
                               foreign_key: 'message_receiver_id'
  has_many :payments
  has_many :notifications, foreign_key: 'recipient_id'

  # validations
  validates_presence_of :user_name, :first_name, :last_name, :gender, :birth_date
  validates :user_name, uniqueness: true
  validates :email, presence: true, uniqueness: true,
                    format: { with: /\A(\w+\.*)+@\w+(\.\w{2,3})+\Z/,
                              message: 'Email should be in this format -> abc@xyz.com' }
  validates :password, presence: true, confirmation: true,
                       format: { with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%&*?])[\w!@#$%&*?]{6,}\Z/,
                                 message: 'password contain minimum 6 character,
                                        atleast 1 uppercase letter 1 number and 1 symbol' }
  validates :password_confirmation, presence: true
  
  # Include default devise modules. Others available are:
  # , :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
end
