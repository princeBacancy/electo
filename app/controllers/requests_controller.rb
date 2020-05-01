# frozen_string_literal: true

# election requests
class RequestsController < ApplicationController
  before_action :authenticate_user!

  def index
    @requests = Request.eager_load(:request_sender, election: [:admin])
                       .paginate(per_page: 10, page: params[:page])
  end

  def send_requests
    @requests = Request.eager_load(:request_sender, election: [:admin])
                       .where(request_sender_id: params[:id])
                       .paginate(per_page: 10, page: params[:page])
  end

  def received_requests
    @requests = Request.joins(:election).where('elections.admin_id=?', params[:id])
                       .paginate(per_page: 10, page: params[:page])
  end

  def election_requests
    @requests = Request.where(election_id: params[:id])
                       .paginate(per_page: 10, page: params[:page])
  end

  def new
    request = Request.get_request(current_user, params)
    if !request
      new_request
    elsif request
      flash[:status] = 'request already send'
      redirect_to send_requests_request_path(current_user.id)
    end
  end

  def approve
    @request = Request.includes(:election).find_by(id: params[:id])
    if @request && @request.purpose == 'candidate'
      @request.election.payments.build(user_id: @request.request_sender_id,
                                       amount: 50).save
    end
    notification = @request.request_sender.notifications.build(notification: "your request to be #{@request.purpose} in election #{@request.election.title} is approved",
                                                               read_at: nil)
    # ActionCable.server.broadcast('notification_channel',
    #                              notification: notification)
    flash[:status] = 'notification problem' unless notification&.save
    RequestConfirmedMailer.request_confirmed(@request).deliver
    if @request&.update(status: :approved)
      flash[:status] = 'request approved!!!'
      redirect_to received_requests_request_path(current_user.id)
    end
  end

  def destroy
    @request = Request.find_by(id: params[:id])

    flash[:status] = if @request && @request.destroy
                       'deleted successfuly'
                     else
                       'failed!!!'
                     end
    redirect_to send_requests_request_path(current_user.id)
  end

  def import_voters
    Request.import(params[:file], params[:id])
    flash[:status] = 'voters added successfully!!!'
    redirect_to received_requests_request_path(current_user.id)
  end

  private

  def new_request
    request = Request.create_request(current_user, params)
    if request && Request.time_out?(request)
      if request.save

        notification = request.election.admin.notifications.build(notification: "new request from #{request.request_sender.user_name} to be #{request.purpose} in election #{request.election.title}",
                                                                   read_at: nil)
        # ActionCable.server.broadcast('notification_channel',
        #                              notification: notification)
        flash[:status] = 'notification problem' unless notification&.save
        flash[:status] = 'request send to election admin!!!'
        redirect_to send_requests_request_path(current_user.id)
      else
        flash[:status] = 'something went wrong!!!'
        render election_path
      end
    else
      flash[:status] = 'time out!!!'
      redirect_to send_requests_request_path(current_user.id)
    end
  end
end
