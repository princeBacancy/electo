class CreateElectionData < ActiveRecord::Migration[6.0]
  def change
    create_table :election_data do |t|
      t.references :election, null: false, foreign_key: true
      t.references :candidate
      t.integer :votes_count

      t.timestamps
    end
  end
end
