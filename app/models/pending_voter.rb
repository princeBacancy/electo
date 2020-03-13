# frozen_string_literal: true

# manages all voters which has no account in our website
class PendingVoter < ApplicationRecord
  # relations
  belongs_to :election

  # validations
  validates_presence_of :election_id, :email
  validates_uniqueness_of :election_id, :scope => :email, presence: true
end
