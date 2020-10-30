require 'test_helper'

class SupportRequestMailerTest < ActionMailer::TestCase
  test "received" do
    support_request = support_requests(:one)
    mail = SupportRequestMailer.respond(support_requests(:one))
    assert_equal "Re: #{support_request.subject}", mail.subject
    assert_equal ["dave@example.org"], mail.to
    assert_equal ["support@example.com"], mail.from
    assert_match /#{support_request.body}/, mail.body.encoded
    assert_match /#{support_request.response.body.to_s.split.join(' ')}/, mail.body.encoded.split.join(' ')
  end

end
