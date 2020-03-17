class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.references :recipient
      t.text :notification
      t.datetime :read_at

      t.timestamps
    end
  end
end
