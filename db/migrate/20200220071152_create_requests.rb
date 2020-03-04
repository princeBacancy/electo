class CreateRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :requests do |t|
      t.references :request_sender
      t.references :request_receiver
      t.references :election
      t.string :purpose
      t.integer :status, default:0

      t.timestamps
    end
  end
end
