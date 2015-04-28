class AccountsController < ApplicationController
  before_filter :authenticate!

  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    if current_user.update(account_params)
      redirect_to account_path, flash: { success: "Update Successful" }
    else
      render :edit
    end
  end

  private

  def account_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
