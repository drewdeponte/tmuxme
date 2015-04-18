class AuthController < ApplicationController
  def callback
    user = User.find_or_create_from_auth_hash(auth_hash)

    if user
      session[:user_id] = user.id
      redirect_to root_url, flash: { success: "Thank you for signing up!" }
    else
      redirect_to new_user_url, flash: { error: "Error encountered creating your account" }
    end
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
