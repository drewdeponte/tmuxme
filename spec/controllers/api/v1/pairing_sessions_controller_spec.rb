require 'rails_helper'

describe Api::V1::PairingSessionsController do
  describe "POST create" do
    it "renders empty JSON with a status of 200" do
      post :create, system_user: 'adeponte', pairing_users: ['bob', 'cindy'], port_number: 6342
      expect(response.status).to eq(200)
    end
  end
end
