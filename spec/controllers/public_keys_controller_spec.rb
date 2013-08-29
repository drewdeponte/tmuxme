require 'spec_helper'

describe PublicKeysController do
  describe "GET index" do
    context "when user is logged in" do
      let(:current_user_mock) { double('current user') }

      before do
        allow(controller).to receive(:current_user).and_return(current_user_mock)
      end

      it "gets all the users public keys" do
        expect(current_user_mock).to receive(:public_keys)
        get :index
      end

      it "assigns the public keys" do
        public_keys_stub = double('public keys')
        allow(current_user_mock).to receive(:public_keys).and_return(public_keys_stub)
        get :index
        expect(assigns(:public_keys)).to eq(public_keys_stub)
      end

      it "renders the index template" do
        allow(current_user_mock).to receive(:public_keys)
        get :index
        response.should render_template('index')
      end
    end

    context "when user is NOT logged in" do
      before do
        allow(controller).to receive(:current_user)
      end

      it "redirects to the login path" do
        get :index
        expect(response).to redirect_to(new_session_path)
      end
    end
  end
end
