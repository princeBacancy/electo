# frozen_string_literal: true

class ChargesController < ApplicationController
  
  def new
    @@election = Election.includes(:election_data).find(params[:election_id])
  end

  def create
    # Amount in cents
    @amount = 50

    customer = Stripe::Customer.create({
                                         email: params[:stripeEmail],
                                         source: params[:stripeToken]
                                       })

    charge = Stripe::Charge.create({
                                     customer: customer.id,
                                     amount: @amount * 100,
                                     description: 'Rails Stripe customer',
                                     currency: 'inr'
                                   })
    manage_candidate
    flash[:status] = 'payment success'
    redirect_to :root
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path
  end

  private

  def manage_candidate
    @@election.payments.find_by(user_id: current_user.id).update(status: :confirmed)
    @@election.election_data.build(candidate_id: current_user.id).save
  end
end
