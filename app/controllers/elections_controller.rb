# frozen_string_literal: true

class ElectionsController < ApplicationController
  before_action :find_election, except: %i[index new create election_params result vote start]
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
    if @election.update(approval_status: :approved)
      ConfirmedElectionMailer.confirmed(@election).deliver
    end
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
    @election = Election.includes(:requests).find(params[:id])
    if (current_user == @election.admin) && (@election.approval_status == 'approved') && (@election.status != 'live')
      @election.update(status: 'live')
      @voters = @election.requests.where(status: :approved)
      @voters.each do |voter|
        ElectionLiveNotificationMailer.notify(voter, @election).deliver
      end
    end
  end

  def vote
    @election = Election.includes(:voters, :election_data).find(params[:id])
    if !@election.voters.exists?(voter_id: current_user.id) && @election.status == 'live'
      a = ElectionDatum.left_joins(:candidate).find_by("users.user_name=? AND election_data.election_id=?",params[:election][:candidates], params[:id])
      a.update(votes_count: a.votes_count + 1)

      @election.voters.build(voter_id: current_user.id).save
      
      flash[:status] = "voted successfully to #{params[:election][:candidates]}"
      redirect_to result_election_path(@election.id)
    end
  end

  def end
    if current_user == @election.admin && @election.status == 'live'
      @election.update(status: :suspended)
    end
    redirect_to result_election_path(@election.id)
  end

  def result
    @election = Election.includes(:election_data).find(params[:id])
    if (@election.status == 'suspended') && @election.election_data.exists?
      @winners_data = @election.election_data.maximum_votes.includes(:candidate)
      @winners_data.each do |winner|
        @election.winners.build(election_datum_id: winner.id).save
      end
    end
  end

  private

  def election_params
    params.require('election').permit(:title, :description, :additional_information, :deadline_for_registration, :start_time, :end_time)
  end
end
