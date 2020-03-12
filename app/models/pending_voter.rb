# frozen_string_literal: true

# manages all voters which has no account in our website
class PendingVoter < ApplicationRecord
  belongs_to :election
end
