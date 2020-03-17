# frozen_string_literal: true

# election candidate and votes management
class ElectionDataController < ApplicationController
  before_action :authenticate_user!
  def index
    @election_data = ElectionDatum.includes(:election)
                                  .where(election_id: params[:id])
  end

  def destroy
    election_data = ElectionDatum.find_by(id: params[:id])
    unless election_data.destroy
      flash[:status] = "Failed!!!!"
    end 
  end
end
