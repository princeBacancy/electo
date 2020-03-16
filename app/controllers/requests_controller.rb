# frozen_string_literal: true

# election requests
class RequestsController < ApplicationController
  before_action :authenticate_user!

  def index
    @requests = Request.includes(:request_sender, election: [:admin]).all
    @requests = @requests.paginate(per_page: 10, page: params[:page])
  end

  def send_requests
    @requests = Request.includes(:request_sender, election: [:admin])
                       .where(request_sender_id: params[:id])
    @requests = @requests.paginate(per_page: 10, page: params[:page])
  end

  def received_requests
    @requests = Request.joins(:election).where('elections.admin_id=?', params[:id])
    @requests = @requests.paginate(per_page: 10, page: params[:page])
  end

  def election_requests
    @requests = Request.where(election_id: params[:id])
    @requests = @requests.paginate(per_page: 10, page: params[:page])
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
    @request = Request.includes(:election).find(params[:id])
    if @request.purpose == 'candidate'
      @request.election.payments.build(user_id: @request.request_sender_id,
                                       amount: 50).save
    end
    RequestConfirmedMailer.request_confirmed(@request).deliver
    if @request.update(status: :approved)
      flash[:status] = 'request approved!!!'
      redirect_to received_requests_request_path(current_user.id)
    end
  end

  def destroy
    @request = Request.find(params[:id])

    flash[:status] = if @request.destroy
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
    if !Request.time_out?(request)
      if request.save
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
