require 'test_helper'

class VotingPermissionMailerTest < ActionMailer::TestCase
  test "voting_permission" do
    mail = VotingPermissionMailer.voting_permission
    assert_equal "Voting permission", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
