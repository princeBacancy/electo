# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/request_confirmed_mailer
class RequestConfirmedMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/request_confirmed_mailer/request_confirmed
  def request_confirmed
    RequestConfirmedMailer.request_confirmed
  end
end
