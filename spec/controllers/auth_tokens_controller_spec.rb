require 'rails_helper'

describe AuthTokensController do
  let(:auth_hash) { OmniAuth.config.mock_auth[:github] }
  before do
    # Mock defined in rails_helper
    request.env["omniauth.auth"] = auth_hash
  end

  describe "GET index" do
    context "when the user is logged in" do
      let(:current_user) { double('current user') }

      before do
        allow(controller).to receive(:current_user).and_return(current_user)
      end

      it "assigns auth tokens to @auth_tokens" do
        auth_tokens = double('auth_tokens')
        allow(current_user).to receive(:auth_tokens).and_return(auth_tokens)
        get :index
        expect(assigns[:auth_tokens]).to eq(auth_tokens)
      end
    end
  end

  describe "DELETE destroy" do
    context "when the user is logged in" do
      let(:current_user) { double('current user') }

      before do
        allow(controller).to receive(:current_user).and_return(current_user)
      end

      it "finds the auth_token associated with the user" do
        auth_tokens = double('auth_tokens')
        allow(current_user).to receive(:auth_tokens).and_return(auth_tokens)
        expect(auth_tokens).to receive(:find).with("1")
        delete :destroy, {id: "1"}
      end

      context "when it finds the auth token" do
        it "destroys the auth token" do
          auth_tokens = double('auth_tokens')
          auth_token = double('auth_token')
          allow(current_user).to receive(:auth_tokens).and_return(auth_tokens)
          allow(auth_tokens).to receive(:find).and_return(auth_token)
          expect(auth_token).to receive(:destroy)
          delete :destroy, {id: "1"}
        end
      end

      it "redirects to the auth tokens path" do
        auth_tokens = double('auth_tokens').as_null_object
        allow(current_user).to receive(:auth_tokens).and_return(auth_tokens)
        delete :destroy, {id: "1"}
        expect(response).to redirect_to(auth_tokens_path)
      end
    end

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
