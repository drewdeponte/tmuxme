class AuthTokensController < ApplicationController
  before_filter :authenticate!, only: [:index, :destroy]

  def index
    @auth_tokens = AuthTokenProcessor.auth_token_hash_from(current_user)
  end

  def destroy
    auth_token = current_user.auth_tokens.find(params[:id])
    auth_token.destroy if auth_token.present?

    redirect_to auth_tokens_path, flash: {success: "Token successfully removed"}
  end

  def callback
    if current_user.present?
      AuthTokenProcessor.register_auth_token(current_user, auth_hash)
      redirect_to auth_tokens_path
    else
      new_user_signup
    end

  rescue AuthTokenSignUpError => e
    redirect_to new_user_url, flash: { error: e.message }
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end

  def new_user_signup
    user = AuthTokenProcessor.find_or_create_user_from_auth_hash(auth_hash)

    if user
      session[:user_id] = user.id
      if user.new_user
        message = "Successfully signed up"
      else
        message = "Successfully logged in"
      end
      redirect_to root_url, flash: { success: message }
    else
      redirect_to new_user_url, flash: { error: "Error encountered creating your account" }
    end
  end
end
