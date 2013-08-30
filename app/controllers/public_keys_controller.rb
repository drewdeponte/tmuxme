class PublicKeysController < ApplicationController
  before_action :authenticate!

  def index
    @public_keys = current_user.public_keys
  end

  def new
    @public_key = PublicKey.new
    render :new
  end

  def create
    current_user.public_keys.create!(public_key_params)
    AuthorizedKeysGenerator.generate_and_write
    redirect_to public_keys_path
  end

  def destroy
    public_key = current_user.public_keys.find_by_id(params[:id])
    if public_key
      public_key.destroy
      AuthorizedKeysGenerator.generate_and_write
    end
    redirect_to public_keys_path
  end

  private

  def public_key_params
    params.require(:public_key).permit(:name, :value)
  end
end
