# frozen_string_literal: true

# it manages all voting details
class VotingListsController < ApplicationController
  def index
    @votes = VotingList.includes(:election).where(election_id: params[:id])
    @votes = @votes.paginate(per_page: 10, page: params[:page])
  end

  def destroy
    VotingList.find(params[:id]).destroy
  end
end
