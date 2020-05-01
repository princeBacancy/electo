# frozen_string_literal: true

# this controller manages all winner records
class WinnersController < ApplicationController
  def index
    @winners = Winner.eager_load(:election, election_datum: [:candidate])
                     .where(election_id: params[:id])
                     .paginate(per_page: 10, page: params[:page])
  end

  def destroy
    winner = Winner.find_by(id: params[:id])
    unless winner.destroy
      flash[:errors] = "failed!!!"
    end
  end
end
