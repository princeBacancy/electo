class ElectionDatum < ApplicationRecord

  belongs_to :election, dependent: :destroy
  belongs_to :candidate, class_name:"User", foreign_key: "candidate_id"
  has_one :winner
  
  scope :maximum_votes, -> {where(votes_count: self.maximum(:votes_count))}
end
