class RequestsController < ApplicationController
    def index
        @requests = Request.all
    end

    def new
        @election = Election.find(params[:id])
        request = Request.where(request_sender_id:current_user.id, request_receiver_id:@election.admin_id, election_id:@election.id, purpose:params[:type])

        if request.empty?
            
            @request = Request.new(request_sender_id:current_user.id, request_receiver_id:@election.admin_id, election_id:@election.id, purpose:params[:type])
            if @request.save
                flash[:status] = "request send to election admin!!!"
                RequestConfirmMailer.request_confirm(@request).deliver
                redirect_to requests_path(current_user.id)
            else
                flash[:status] = "something went wrong!!!"
                render election_path
            end
        else
            flash[:status] = "request already send"
            redirect_to requests_path(current_user.id)
        end
    end

    def approve
        @request = Request.find(params[:id])
        @request.update(status: true)
        RequestConfirmedMailer.request_confirmed(@request).deliver
        if current_user and current_user.id == @request.election.admin_id
            flash[:status] = "request approved!!!"   
            redirect_to requests_path(current_user.id)
        end
    end

    def destroy
        @request = Request.find(params[:id])
        @request.destroy
        flash[:status] = "deleted successfuly"
        redirect_to requests_path(current_user.id)
    end

    def import_voters
        Request.import(params[:file], params[:id])
        flash[:status] = "voters added successfully!!!"#, user does not exist: #{@user_does_not_exist}"
        redirect_to requests_path(current_user.id)
    end

end
