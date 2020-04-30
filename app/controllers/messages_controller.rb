# frozen_string_literal: true

class MessagesController < ApplicationController
  before_action :authenticate_user!

  def new
    @election = Election.eager_load(messages: [:message_sender]).order("messages.created_at DESC").find_by(id: params[:election_id])
    @message = Message.new
  end

  def create
    message = current_user.messages.build(election_id: params[:message][:election_id], message: params[:message][:message])
    if message.save
      ActionCable.server.broadcast 'e_room_channel',
                                   message: message.message,
                                   sender: message.message_sender.user_name,
                                   election_id: message.election_id
    else
      flash[:status] = 'failed'
    end
  end

  def destroy; end

  def show; end

  private

  # def message_params
  #   params.require(:message).permit(:message_sender, :message, :election)
  # end
end
