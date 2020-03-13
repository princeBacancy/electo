# frozen_string_literal: true

# model for winners
class Winner < ApplicationRecord
  # relations
  belongs_to :election
  belongs_to :election_datum

  # validations
  validates_presence_of :election_id, :election_datum_id
  validates :election_id, uniqueness: {scope: :election_datum_id}
end
