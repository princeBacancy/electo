# frozen_string_literal: true

# payments
class Payment < ApplicationRecord
  # relations
  belongs_to :user
  belongs_to :election

  # validations
  validates_presence_of :election_id, :user_id

  # enums
  enum status: %i[pending confirmed failed]
end
