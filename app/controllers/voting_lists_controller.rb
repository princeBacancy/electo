# frozen_string_literal: true

# it manages all voting details
class VotingListsController < ApplicationController
  def index
    @votes = VotingList.includes(:election).where(election_id: params[:id])
                       .paginate(per_page: 10, page: params[:page])
  end

  def destroy
    voter = VotingList.find_by(id: params[:id])
    flash[:errors] = 'failed!!!' unless voter.destroy
  end
end
