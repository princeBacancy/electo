class Winner < ApplicationRecord
  belongs_to :election
  belongs_to :election_datum
end
