class UserMailer < ActionMailer::Base
  def password_reset(user)
    @user = user
    mail :to => user.email
  end
end
