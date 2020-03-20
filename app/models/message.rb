# frozen_string_literal: true

# manages all communication
class Message < ApplicationRecord
 belongs_to :message_sender, class_name: 'User'
 belongs_to :election
end
