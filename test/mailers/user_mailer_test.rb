require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  setup do
    @user = users(:user_1)
  end
  test "password_reset" do
    mail = UserMailer.password_reset(@user)
    assert_equal "Password reset", mail.subject
    assert_equal [@user.email], mail.to
    assert_equal ['photoblogapp@gmail.com'], mail.from
    assert_match @user.password_reset_token, mail.body.encoded
  end

end
