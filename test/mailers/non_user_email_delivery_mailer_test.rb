require 'test_helper'

class NonUserEmailDeliveryMailerTest < ActionMailer::TestCase
  test "email_delivery" do
    mail = NonUserEmailDeliveryMailer.email_delivery
    assert_equal "Email delivery", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
