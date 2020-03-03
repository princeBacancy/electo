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
    @election.update(approval_status: 1)
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
    @election.update(status: 1) if current_user == @election.admin and @election.approval_status
  end

  def vote
    if !VotingList.exists?(voter_id: current_user.id, election_id: @election.id) && @election.status
      @candidate = User.find_by(user_name: params[:election][:candidates])
      @candidate_data = ElectionDatum.find_by(candidate_id: @candidate.id, election_id: params[:id])
      @candidate_data.update(votes_count: @candidate_data.votes_count + 1)
      @voter = VotingList.create(voter_id: current_user.id, election_id: params[:id])
      flash[:status] = "voted successfully to #{params[:election][:candidates]}"
      redirect_to result_election_path
    end
  end

  def end
    @election.update(status: 0, approval_status: 0) if current_user == @election.admin
  end

  def result; end

  private

  def election_params
    params.require('election').permit(:title, :description, :additional_information, :deadline_for_registration, :start_time, :end_time)
  end
end
