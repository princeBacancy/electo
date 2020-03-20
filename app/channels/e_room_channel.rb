class ERoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "e_room_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
