# frozen_string_literal: true

# it records who when voted in which election
class VotingList < ApplicationRecord
  # relations
  belongs_to :voter, class_name: 'User', foreign_key: 'voter_id'
  belongs_to :election, class_name: 'Election', foreign_key: 'election_id'

  # validations
  validates_presence_of :voter_id, :election_id
  validates :voter_id, uniqueness: {scope: :election_id}
end
