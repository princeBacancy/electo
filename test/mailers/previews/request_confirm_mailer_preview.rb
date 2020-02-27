# Preview all emails at http://localhost:3000/rails/mailers/request_confirm_mailer
class RequestConfirmMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/request_confirm_mailer/request_confirm
  def request_confirm
    RequestConfirmMailer.request_confirm
  end

end
