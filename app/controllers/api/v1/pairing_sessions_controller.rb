class Api::V1::PairingSessionsController < ApplicationController
  protect_from_forgery :except => [:create]
  def create
    InviteMailer.invite(params[:system_username], params[:pairing_users], params[:port_number]).deliver
    render json: {}
  end
end
