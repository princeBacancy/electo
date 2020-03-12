# frozen_string_literal: true

# model for winners
class Winner < ApplicationRecord
  belongs_to :election
  belongs_to :election_datum
end
