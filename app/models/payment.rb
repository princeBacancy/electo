class Payment < ApplicationRecord
  belongs_to :user
  belongs_to :election

  validates_presence_of :election_id, :user_id

  enum status: %i[pending confirmed failed]
end
