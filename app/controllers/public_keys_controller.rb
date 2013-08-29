class PublicKeysController < ApplicationController
  before_action :authenticate!

  def index
    @public_keys = current_user.public_keys
  end
end
