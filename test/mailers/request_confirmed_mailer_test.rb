require 'test_helper'

class RequestConfirmedMailerTest < ActionMailer::TestCase
  test "request_confirmed" do
    mail = RequestConfirmedMailer.request_confirmed
    assert_equal "Request confirmed", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
