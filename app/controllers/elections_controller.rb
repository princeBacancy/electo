# frozen_string_literal: true

# election management
class ElectionsController < ApplicationController
  before_action :find_election, only: %i[edit update confirm destroy end]
  before_action :authenticate_user!

  def index
    @elections = Election.eager_load(:election_data, :winners,
                                     :requests, :pending_voters,
                                     :voters, :payments).order_by_status
  end

  def my_elections
    @elections = Election.eager_load(:election_data, :winners,
                                     :requests, :pending_voters,
                                     :voters, :payments).all
  end

  def new
    @election = Election.new
  end

  def create
    @election = current_user.elections.build(election_params)
    if @election&.save
      flash[:status] = 'request send to super admin for approval'
      redirect_to :root
    else
      flash[:errors] = @election.errors.full_messages
      redirect_to new_election_path
    end
  end

  def show
    @election = Election.includes(:pending_voters, :requests)
                        .find_by(id: params[:id])
  end

  def update
    if @election.update(election_params)
      redirect_to :root
    else
      flash[:errors] = e.message
      render new_election_path
    end
  end

  def confirm
    if @election&.update(approval_status: :approved)
      notification = @election.admin.notifications.build(notification: "your election #{@election.title} is approved", read_at: nil)
      # ActionCable.server.broadcast('notification_channel',
      #                              notification: notification)
      flash[:errors] = 'notification problem' unless notification&.save

      ConfirmedElectionMailer.confirmed(@election).deliver
      if current_user
        flash[:status] = 'thank you for approval'
        redirect_to :root
      end
    elsif current_user
      flash[:errors] = 'failed!!!'
      render :root
    end
  end

  def destroy
    if @election&.destroy
      redirect_to :root
      flash[:status] = 'destroyed!!!'
    else
      flash[:errors] = 'failed!!!'
    end
  end

  def start
    @election = Election.eager_load(:requests, :voters, election_data: :candidate)
                        .find_by(id: params[:id])
    if @election && (current_user == @election.admin) &&
       (@election.approval_status == 'approved') &&
       (@election.status == 'waiting')
      start_election(@election)
    elsif !@election
      flash[:errors] = 'failed!!!'
      render 'show'
    end
  end

  def vote
    @election = Election.includes(:voters, :election_data).find_by(id: params[:id])
    if @election && !@election.voters.exists?(voter_id: current_user.id) &&
       @election.status == 'live'
      if ElectionDatum.increase_vote(params)
        @election.voters.build(voter_id: current_user.id).save
        flash[:status] = "voted successfully to #{params[:election][:candidates]}"
        redirect_to result_election_path(@election.id)
      else
        flash[:errors] = 'failed to vote'
        redirect_to start_election_path
      end
    end
  end

  def end
    if @election && current_user == @election.admin && @election.status == 'live' && @election
       .update(status: :suspended)
      redirect_to result_election_path(@election.id)
    else
      flash[:errors] = 'failed!!!'
      render 'show'
    end
  end

  def result
    @election = Election.includes(:election_data, :requests).find_by(id: params[:id])
    if @election && (@election.status == 'suspended') && @election.election_data
      @winners_data = @election.election_data.maximum_votes.includes(:candidate)
      @winners_data.each do |winner|
        @election.winners.build(election_datum_id: winner.id).save
      end
    end
  end

  def sample_file_download
    send_file(
      "#{Rails.root}/public/sample.csv",
      filename: 'voters.csv',
      type: 'application/csv'
    )
  end

  private

  def start_election(election)
    election.update(status: 'live', deadline_for_registration: DateTime.now,
                    start_time: DateTime.now,
                    end_time: DateTime.now)
    notify_voters(election)
  end

  def notify_voters(election)
    voters = election.requests.where(status: :approved)
    voters.each do |voter|
      ElectionLiveNotificationMailer.notify(voter, election).deliver
    end
  end

  def find_election
    @election = Election.find_by(id: params[:id])
  end

  def election_params
    params.require('election').permit(:title, :description,
                                      :additional_information,
                                      :deadline_for_registration,
                                      :start_time,
                                      :end_time)
  end
end
