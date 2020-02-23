# frozen_string_literal: true

class ElectoController < ApplicationController
  def welcome
    @elections = Election.all
  end
end
