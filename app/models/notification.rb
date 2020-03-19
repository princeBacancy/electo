# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :recipient, class_name: 'User'

  scope :unread_notifications,
        ->(recipient_id) { where(recipient_id: recipient_id, read_at: nil).order('created_at DESC') }
  scope :read_notifications,
        lambda { |recipient_id|
          where(recipient_id: recipient_id, read_at: nil)
            .update(read_at: DateTime.now)
        }
end
