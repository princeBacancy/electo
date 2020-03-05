class CreateVotingLists < ActiveRecord::Migration[6.0]
  def change
    create_table :voting_lists do |t|
      t.references :voter
      t.references :election

      t.timestamps
    end
  end
end
