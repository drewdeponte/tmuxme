class UserMailer < ActionMailer::Base
  default from: "noreply@tmux.me"

  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => "tmux.me: Password Reset"
  end
end
