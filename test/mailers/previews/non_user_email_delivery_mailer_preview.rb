# Preview all emails at http://localhost:3000/rails/mailers/non_user_email_delivery_mailer
class NonUserEmailDeliveryMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/non_user_email_delivery_mailer/email_delivery
  def email_delivery
    NonUserEmailDeliveryMailer.email_delivery
  end

end
