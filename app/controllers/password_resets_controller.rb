class PasswordResetsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user
      user.send_password_reset_email
    else
      flash.now[:error] = "Unrecognized e-mail address!"
      render "new"
    end
  end

  def edit
    @user = User.find_by_password_reset_token!(params[:id])
  end

  def update
    @user = User.find_by_password_reset_token!(params[:id])
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, :flash => { :notice => "Password reset has expired." }
    elsif @user.update_attributes(user_params)
      redirect_to new_session_path, :flash => { :success => "Password has been reset." }
    else
      render "edit"
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
