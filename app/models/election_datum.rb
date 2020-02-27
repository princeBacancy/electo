class ElectionDatum < ApplicationRecord
  belongs_to :election
  belongs_to :candidate, class_name:"User", foreign_key: "candidate_id"
  has_one :winner
end
