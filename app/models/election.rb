# frozen_string_literal: true

class Election < ApplicationRecord
  belongs_to :admin, class_name: 'User', foreign_key: 'admin_id'
  has_many :election_data
  has_one :winner
  has_many :requests
  has_many :panding_voters
end
