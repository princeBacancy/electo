# frozen_string_literal: true

class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.references :message_sender
      t.references :message_receiver
      t.text :message

      t.timestamps
    end
  end
end
