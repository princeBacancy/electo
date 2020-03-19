class AddReferenceToMessages < ActiveRecord::Migration[6.0]
  def change
    add_reference :messages, :election
  end
end
