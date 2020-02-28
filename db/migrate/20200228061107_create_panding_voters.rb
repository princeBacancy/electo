class CreatePandingVoters < ActiveRecord::Migration[6.0]
  def change
    create_table :panding_voters do |t|
      t.references :election, null: false, foreign_key: true
      t.string :email

      t.timestamps
    end
  end
end
