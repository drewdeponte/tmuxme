class Api::V1::PairingSessionsController < ApplicationController
  def create
    InviteMailer.invite(params[:system_username], params[:pairing_users], params[:port_number]).deliver
    render json: {}
  end
end
