# frozen_string_literal: true

class PaymentsController < ApplicationController
  def index
    if current_user.has_role? :super_admin
      @payments = Payment.includes(:election, :user).all
    else
      @payments = Payment.includes(:election, :user).where(user_id: current_user.id,
                                                           status: :pending)
    end
  end

  def election_payments
    @payments = Payment.includes(:election, :user).where(election_id: params[:id])
  end
end
