# frozen_string_literal: true

# manages all elections data
class ElectionDatum < ApplicationRecord
  # relations
  belongs_to :election, dependent: :destroy
  belongs_to :candidate, class_name: 'User', foreign_key: 'candidate_id'
  has_one :winner, dependent: :destroy

  # scopes
  scope :maximum_votes, -> { where(votes_count: maximum(:votes_count)) }

  # validations
  validates_uniqueness_of :election_id, :scope => :candidate_id, presence: true

  def self.increase_vote(params)
    a = ElectionDatum.left_joins(:candidate)
                     .find_by('users.user_name=? AND
                              election_data.election_id=?',
                              params[:election][:candidates],
                              params[:id])
    a.update(votes_count: a.votes_count + 1)
  end
end
