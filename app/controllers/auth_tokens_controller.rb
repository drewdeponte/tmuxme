class AuthTokensController < ApplicationController
  before_filter :authenticate!, only: [:index, :destroy]

  def index
    @auth_tokens = current_user.auth_tokens
  end

  def destroy
    auth_token = current_user.auth_tokens.find(params[:id])
    auth_token.destroy if auth_token.present?

    redirect_to auth_tokens_path, flash: {success: "Token successfully removed"}
  end

  def callback
    user = User.find_or_create_from_auth_hash(auth_hash)

    if user
      session[:user_id] = user.id
      redirect_to root_url
    else
      redirect_to new_user_url, flash: { error: "Error encountered creating your account" }
    end
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
