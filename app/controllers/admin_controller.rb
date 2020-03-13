# frozen_string_literal: true

# all methods in this controller returning entities related
# specific selected user by admin

# it manages all admin rights
class AdminController < ApplicationController
  def index
    @users = User.all if current_user.has_role? :super_admin
  end

  def show_user
    @user = User.find(params[:id])
  end

  def user_elections
    @user = User.includes(:elections).find(params[:id])
  end

  def user_votes
    @user = User.includes(votes: [:election]).find(params[:id])
  end

  def user_candidate
    @user = User.includes(election_data: [:election]).find(params[:id])
  end

  def user_winner
    @user = User.includes(election_data: [:winner]).find(params[:id])
  end
end
