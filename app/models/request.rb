class Request < ApplicationRecord
  belongs_to :request_sender, class_name: "User", foreign_key: "request_sender_id"
  belongs_to :request_receiver, class_name: "User", foreign_key: "request_receiver_id"
  belongs_to :election
end
