require 'rails_helper'

describe AuthController do
  let(:auth_hash) { OmniAuth.config.mock_auth[:github] }
  before do
    # Mock defined in rails_helper
    request.env["omniauth.auth"] = auth_hash
  end

  describe "#callback" do
    let(:user) { double(id: 'the_id') }

    it "looks up a user by auth token" do
      expect(User).to receive(:find_or_create_from_auth_hash).with(auth_hash).and_return(user)
      post :callback, {provider: 'github'}
    end

    context "when a user is not returned" do
      before do
        allow(User).to receive(:find_or_create_from_auth_hash).and_return(nil)
      end

      it "redirects to the new user url" do
        post :callback, {provider: 'github'}
        expect(subject).to redirect_to(new_user_url)
      end
    end

    context "when the user is returned" do
      before do
        allow(User).to receive(:find_or_create_from_auth_hash).and_return(user)
      end

      it "sets the session user_id to the user id" do
        post :callback, {provider: 'github'}
        expect(session[:user_id]).to eq('the_id')
      end

      it "redirects to the root url" do
        post :callback, {provider: 'github'}
        expect(subject).to redirect_to(root_url)
      end
    end
  end
end
