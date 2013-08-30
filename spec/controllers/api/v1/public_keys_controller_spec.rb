require 'spec_helper'

describe Api::V1::PublicKeysController do
  describe "GET index" do
    context "when can't find user" do
      it "responds with a 404 not found" do
        get :index, :user_id => 'bob'
        expect(response.status).to eq(404)
      end
    end

    context "when can find user" do
      context "when the user has no public keys" do
        it "renders an empty JSON array" do
          user = User.create!(:username => 'someuser', :email => 'someuser@example.com', :password => 'bluepork', :password_confirmation => 'bluepork')
          get :index, :user_id => 'bob'
          expect(response.body).to eq('[]')
        end
      end

      context "when the user has a public key" do
        it "runders a JSON array of the public key values" do
          user = User.create!(:username => 'someuser', :email => 'someuser@example.com', :password => 'bluepork', :password_confirmation => 'bluepork')
          user.public_keys.create!(name: 'foo key', value: 'foo key value')
          user.public_keys.create!(name: 'bar key', value: 'bar key value')
          get :index, :user_id => 'someuser'
          expect(response.body).to eq("[\"foo key value\",\"bar key value\"]")
        end
      end
    end
  end
end
