# frozen_string_literal: true

# it manages all voting details
class VotingListsController < ApplicationController
  def index
    @votes = VotingList.includes(:election).where(election_id: params[:id])
  end

  def destroy
    VotingList.find(params[:id]).destroy
  end
end
