require 'test_helper'

class RequestConfirmMailerTest < ActionMailer::TestCase
  test "request_confirm" do
    mail = RequestConfirmMailer.request_confirm
    assert_equal "Request confirm", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
