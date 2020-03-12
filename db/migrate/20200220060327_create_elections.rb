# frozen_string_literal: true

class CreateElections < ActiveRecord::Migration[6.0]
  def change
    create_table :elections do |t|
      t.references :admin
      t.string :title
      t.text :description
      t.text :additional_information
      t.datetime :deadline_for_registration
      t.datetime :start_time
      t.datetime :end_time
      t.integer :status, default: 0
      t.integer :approval_status, default: 0

      t.timestamps
    end
  end
end
