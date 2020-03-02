# frozen_string_literal: true

class NonUserEmailDeliveryMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.non_user_email_delivery_mailer.email_delivery.subject
  #
  def email_delivery(email, election)
    @greeting = 'Hi'
    @election = Election.find(election)
    mail to: email
  end
end
