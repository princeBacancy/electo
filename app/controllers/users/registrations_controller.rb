# frozen_string_literal: true

# user registartion
class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  after_action :assign_default_role_and_permissions, only: [:create]

  # adding role and initial permissions
  def assign_default_role_and_permissions
    @user.add_role :user
    pending_voters = PendingVoter.includes(:election).where(email: @user.email)
    assign_pending_voter_rights(pending_voters, @user) if pending_voters
  end

  private

  def assign_pending_voter_rights(pending_voters, user)
    pending_voters.each do |pending_voter|
      request = Request.new(request_sender_id: user.id, election_id:
                            pending_voter.election.id,
                            purpose: 'voter', status: :approved)
      request.save
      pending_voter.destroy
    end
  end

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
