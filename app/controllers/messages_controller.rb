# frozen_string_literal: true

class MessagesController < ApplicationController
  before_action :authenticate_user!
  def new
    @message = Message.new
  end

  def create
    message = Message.new(message_params)
    if message.save
      ActionCable.server.broadcast 'e_room_channel',
                                   content: message.message
    else
      flash[:status] = 'failed'
    end
  end

  def destroy; end

  def show; end

  private

  def message_params
    params.require(:message).permit(:message_sender, :message, :election)
  end
end
