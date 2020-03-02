class VotingList < ApplicationRecord
  belongs_to :voter, class_name: 'User', foreign_key: 'voter_id'
  belongs_to :election, class_name: 'Election', foreign_key: 'election_id'
end
