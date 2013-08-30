class UserMailer < ActionMailer::Base
  default from: "noreply@tmux.me"

  def password_reset(user)
    @user = user
    mail :to => user.email, :from => "noreply@tmux.me", :subject => "Password Reset"
  end
end
