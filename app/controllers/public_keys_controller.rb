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
    @public_key = current_user.public_keys.new(name: public_key_params[:name], value: public_key_params[:value].strip)
    if @public_key.save
      AuthorizedKeysGenerator.generate_and_write
      redirect_to public_keys_path, flash: { success: "Successfully added your public key!" }
    else
      if !@public_key.errors.empty? && @public_key.errors.messages.has_key?(:value)
        flash[:now] = @public_key.errors.messages[:value][0]
      else
        flash[:now] = "Sorry, we failed to save your public key!"
      end
      render :new
    end
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
