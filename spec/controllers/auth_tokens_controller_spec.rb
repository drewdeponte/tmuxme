require 'rails_helper'
require 'user'

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
        allow(AuthTokenProcessor).to receive(:auth_token_hash_from).with(current_user).and_return(auth_tokens)
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
    context "when a current session is present" do
      let(:user) { double(id: 'the_id', present?: true).as_null_object }
      before { allow(subject).to receive(:current_user).and_return(user) }

      it "registers the new auth token" do
        expect(AuthTokenProcessor).to receive(:register_auth_token)
        post :callback, {provider: 'github'}
      end

      it "redirects to auth tokens page" do
        post :callback, {provider: 'github'}
        expect(response).to redirect_to(auth_tokens_path)
      end
    end

    context "when a current session is not present" do
      before { allow(subject).to receive(:current_user).and_return(nil) }

      it "starts the new user signup" do
        allow(subject).to receive(:render)
        expect(subject).to receive(:new_user_signup)
        post :callback, {provider: 'github'}
      end
    end

    context "when an AuthTokenSignUpError is encountered" do
      before { allow(subject).to receive(:new_user_signup).and_raise(AuthTokenSignUpError, "error message") }

      it "redirects to the new_user_url" do
        post :callback, {provider: 'github'}
        expect(response).to redirect_to(new_user_path)
      end
    end
  end

  describe "#new_user_signup" do
    let(:user) { double(id: 'the_id').as_null_object }

    before { allow(subject).to receive(:auth_hash).and_return(auth_hash) }

    it "looks up a user by auth token" do
      allow(subject).to receive(:redirect_to)
      expect(AuthTokenProcessor).to receive(:find_or_create_user_from_auth_hash).with(auth_hash).and_return(user)
      subject.send(:new_user_signup)
    end

    context "when a user is not returned" do
      before do
        allow(AuthTokenProcessor).to receive(:find_or_create_user_from_auth_hash).and_return(nil)
      end

      it "redirects and sets an error flash message" do
        expect(subject).to receive(:redirect_to).with(new_user_url, {flash: { error: "Error encountered creating your account" }})
        subject.send(:new_user_signup)
      end
    end

    context "when the user is returned" do
      before do
        allow(AuthTokenProcessor).to receive(:find_or_create_user_from_auth_hash).and_return(user)
      end

      it "sets the session user_id to the user id" do
        session = double('session')
        allow(subject).to receive(:redirect_to)
        allow(subject).to receive(:session).and_return(session)
        expect(session).to receive(:[]=).with(:user_id, 'the_id')
        subject.send(:new_user_signup)
      end

      it "redirects to the root url" do
        expect(subject).to receive(:redirect_to).with(root_url, any_args)
        subject.send(:new_user_signup)
      end

      context "when user is a new user" do
        before { allow(user).to receive(:new_user).and_return(true) }

        it "sets the flash message for a successful signup" do
          expect(subject).to receive(:redirect_to).with(root_url, {flash: { success: "Successfully signed up" }})
          subject.send(:new_user_signup)
        end
      end

      context "when user is not a new user" do
        before { allow(user).to receive(:new_user).and_return(nil) }

        it "sets the flash message for a successful signup" do
          expect(subject).to receive(:redirect_to).with(root_url, {flash: { success: "Successfully logged in" }})
          subject.send(:new_user_signup)
        end
      end
    end
  end
end
