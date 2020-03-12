# frozen_string_literal: true

class CreateElectionData < ActiveRecord::Migration[6.0]
  def change
    create_table :election_data do |t|
      t.references :election, null: false, foreign_key: true
      t.references :candidate
      t.integer :votes_count, default: 0

      t.timestamps
    end
  end
end
