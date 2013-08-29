class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_url, flash: { success: "Logged in!" }
    else
      flash.now[:error] = "Email or password is invalid!"
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, flash: { success: "Logged out!" }
  end
end
