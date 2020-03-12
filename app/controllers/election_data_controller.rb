# frozen_string_literal: true

# election candidate and votes management
class ElectionDataController < ApplicationController
  before_action :authenticate_user!
  def index
    @election_data = ElectionDatum.includes(:election)
                                  .where(election_id: params[:id])
  end

  def destroy
    ElectionDatum.find(params[:id]).destroy
  end
end
