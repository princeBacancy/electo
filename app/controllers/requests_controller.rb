
# frozen_string_literal: true

class RequestsController < ApplicationController
  before_action :authenticate_user!

  def index
    @requests = Request.includes(:request_sender, election: [:admin]).all
  end

  def new
    @election = Election.includes(:requests).find(params[:id])
    request = @election.requests.where(request_sender_id: current_user.id, purpose: params[:type])

    if request.empty? and !(@election.deadline_for_registration.strftime('%d %b %Y %H:%M') <= DateTime.now.strftime('%d %b %Y %H:%M'))

      @request = @election.requests.build(request_sender_id: current_user.id, purpose: params[:type])
      if @request.save
        flash[:status] = 'request send to election admin!!!'
        RequestConfirmMailer.request_confirm(@request).deliver
        redirect_to requests_path(current_user.id)
      else
        flash[:status] = 'something went wrong!!!'
        render election_path
      end
    elsif !request.empty?
      flash[:status] = 'request already send'
      redirect_to requests_path(current_user.id)
    else
      flash[:status] = 'Time Out!!!'
      redirect_to requests_path(current_user.id)
    end
  end

  def approve
    @request = Request.includes(:election).find(params[:id])
    if @request.update(status: :approved)
      if @request.purpose == 'candidate'
        @request.election.election_data.build(candidate_id: @request.request_sender_id).save
      end
      RequestConfirmedMailer.request_confirmed(@request).deliver
      if current_user && (current_user.id == @request.election.admin_id)
        flash[:status] = 'request approved!!!'
        redirect_to requests_path(current_user.id)
      end
    end
  end

  def destroy
    @request = Request.find(params[:id])
    if @request.destroy
      flash[:status] = 'deleted successfuly'
      redirect_to requests_path(current_user.id)
    end
  end

  def import_voters
    Request.import(params[:file], params[:id])
    flash[:status] = 'voters added successfully!!!'
    redirect_to requests_path(current_user.id)
  end
end
