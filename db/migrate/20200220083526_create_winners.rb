# frozen_string_literal: true

class CreateWinners < ActiveRecord::Migration[6.0]
  def change
    create_table :winners do |t|
      t.references :election, null: false, foreign_key: true
      t.references :election_datum, null: false, foreign_key: true

      t.timestamps
    end
  end
end
