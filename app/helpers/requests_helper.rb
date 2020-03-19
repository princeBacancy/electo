# frozen_string_literal: true

module RequestsHelper
  def request?(election)
    election.requests.exists?(request_sender_id: current_user.id, purpose: "voter", status: :approved)
  end
end
