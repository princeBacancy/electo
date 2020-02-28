class ElectionsController < ApplicationController
    before_action :find_election, except: [:index, :new, :create, :election_params] 
    
    def index
    
    end

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
            flash[:status] = "request send to super admin for approval"
            redirect_to :root
        else
            flash[:errors] = @election.errors.full_messages
            render new_election_path
        end
    end

    def show
    end

    def edit
    end

    def update
        if @election.update(election_params)
            redirect_to :root
        else
            flash[:errors] = @election.errors.full_messages
            render new_election_path
        end
    end

    def confirm
        @election.update(approval_status:1)
        ConfirmedElectionMailer.confirmed(@election).deliver
        if current_user and current_user.has_role? :super_admin
            flash[:status] = "thank you for approval"
            redirect_to :root
        end
    end

    def destroy
        @election.destroy
        redirect_to :root
    end

    def start
        @election.update(status: 1)
        redirect_to live_election_path
    end

    def end
        @election.update(status: 0)
        redirect_to result_election_path
    end
    
    def result
    end

    private
    def election_params
        params.require("election").permit(:title, :description, :additional_information, :deadline_for_registration, :start_time, :end_time)
    end
end
