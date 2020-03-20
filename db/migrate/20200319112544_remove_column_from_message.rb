class RemoveColumnFromMessage < ActiveRecord::Migration[6.0]
  def change
    remove_column :messages, :message_receiver_id, :bigint
  end
end
