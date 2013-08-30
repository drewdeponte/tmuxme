class InviteMailer < ActionMailer::Base
  default from: "noreply@tmux.me"

  def invite(system_user, pair_users, port_number)
    @system_user = system_user
    @port_number = port_number
    pair_users.each do |pair_name|
      @current_user = User.find_by_username(pair_name)
      if @current_user.present?
        mail :to => @current_user.email, :subject => "Invite to Join a http://tmux.me pair programming session"
      end
    end
  end
end
