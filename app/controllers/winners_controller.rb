# frozen_string_literal: true

# this controller manages all winner records

class WinnersController < ApplicationController
  def index
    @winners = Winner.includes(:election, election_datum: [:candidate]).where(election_id: params[:id])
  end

  def destroy
    Winner.find(params[:id]).destroy
  end
end
