class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to products_path, :alert => exception.message
  end

  private

  def authenticate!
    if current_user.present?
      return true
    else
      flash[:error] = "You need to be logged in to access that!"
      redirect_to new_session_path
      return false
    end
  end
  helper_method :authenticate!

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user
end
