class PaymentsController < ApplicationController
  def index
    if current_user.has_role? :super_admin
      @payments = Payment.all
    else
      @payments = Payment.where(user_id: current_user.id, status: :pending)
    end
  end
end
