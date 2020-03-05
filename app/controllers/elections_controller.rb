# frozen_string_literal: true

class ElectionsController < ApplicationController
  before_action :find_election, except: %i[index new create election_params]
  before_action :authenticate_user!

  def index; end

  def find_election
    @election = Election.find(params[:id])
  end

  def new
    @election = Election.new
  end

  def create
    @election = Election.new(election_params)
    @election.admin_id = current_user.id
    if @election.save
      ConfirmElectionMailer.confirmation(@election).deliver
      flash[:status] = 'request send to super admin for approval'
      redirect_to :root
    else
      flash[:errors] = @election.errors.full_messages
      render new_election_path
    end
  end

  def show; end

  def edit; end

  def update
    if @election.update(election_params)
      redirect_to :root
    else
      flash[:errors] = @election.errors.full_messages
      render new_election_path
    end
  end

  def confirm
    @election.update(approval_status: :approved)
    ConfirmedElectionMailer.confirmed(@election).deliver
    if current_user.has_role?(:super_admin)
      flash[:status] = 'thank you for approval'
      redirect_to :root
    end
  end

  def destroy
    @election.destroy
    redirect_to :root
  end

  def start
    if (current_user == @election.admin) && (@election.approval_status == 'approved') && (@election.status != 'live')
      @election.update(status: 'live')
      @voters = @election.requests.where(status: :approved)
      @voters.each do |voter|
        ElectionLiveNotificationMailer.notify(voter, @election).deliver
      end
    end
  end

  def vote
    if !VotingList.exists?(voter_id: current_user.id, election_id: @election.id) && @election.status == 'live'
      @candidate = User.find_by(user_name: params[:election][:candidates])
      @candidate_data = ElectionDatum.find_by(candidate_id: @candidate.id, election_id: params[:id])
      @candidate_data.update(votes_count: @candidate_data.votes_count + 1)
      @voter = VotingList.create(voter_id: current_user.id, election_id: params[:id])
      flash[:status] = "voted successfully to #{params[:election][:candidates]}"
      redirect_to result_election_path(@election.id)
    end
  end

  def end
    @election.update(status: :suspended) if current_user == @election.admin
    redirect_to result_election_path(@election.id)
  end

  def result
    @election_data = ElectionDatum.where(election_id: @election.id)
    if (@election.status == 'suspended') && @election.election_data.exists?
      @winner = @election_data.order('votes_count DESC').first
      @winners = @election_data.where(votes_count: @winner.votes_count)
      @winners.each do |winner|
        Winner.create(election_id: @election.id, election_datum_id: winner.id)
      end
    end
  end

  private

  def election_params
    params.require('election').permit(:title, :description, :additional_information, :deadline_for_registration, :start_time, :end_time)
  end
end
