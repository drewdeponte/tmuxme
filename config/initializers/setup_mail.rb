ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :user_name            => "noreply@tmux.me",
  :password             => "porkbork",
  :authentication       => "plain",
  :enable_starttls_auto => true
}
