class ElectionsController < ApplicationController

    def index
    
    end

    def new
        @election = Election.new
    end

    def create
        @election = Election.new(election_params)
        @election.admin_id = current_user.id
        if @election.save
            ConfirmElectionMailer.confirmation(@election).deliver
            flash[:status] = "request send to super admin for approval"
            redirect_to :root
        else
            flash[:errors] = @election.errors.full_messages
            render new_election_path
        end
    end

    def show
        @election = Election.find(params[:id])
    end

    def edit
        @election = Election.find(params[:id])
    end

    def update
        @election = Election.find(params[:id])
        
        if @election.update(election_params)
            redirect_to :root
        else
            flash[:errors] = @election.errors.full_messages
            render new_election_path
        end
    end

    def confirm
        @election = Election.find(params[:id])
        @election.update(approval_status:1)
        ConfirmedElectionMailer.confirmed(@election).deliver
        if current_user and current_user.has_role? :super_admin
            flash[:status] = "thank you for approval"
            redirect_to :root
        end
    end

    def destroy
        @election = Election.find(params[:id])
        @election.destroy
        redirect_to :root
    end

    def election_params
        params.require("election").permit(:title, :description, :additional_information, :deadline_for_registration, :start_time, :end_time)
    end
end
