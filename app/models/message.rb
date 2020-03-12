# frozen_string_literal: true

# manages all communication
class Message < ApplicationRecord
  belongs_to :message_sender, class_name: 'User',
                              foreign_key: 'message_sender_id'
  belongs_to :message_receiver, class_name: 'User',
                                foreign_key: 'message_receiver_id'
end
