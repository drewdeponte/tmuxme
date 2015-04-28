require 'rails_helper'

describe AuthTokenProcessor do
  subject { AuthTokenProcessor }

  describe ".create_user_from_auth_hash" do
    let(:user) { double('user').as_null_object }
    let(:auth_hash) { double('auth_hash').as_null_object }

    context "when the user already exists" do
      before { allow(User).to receive(:exists?).and_return(true) }

      it "throws an AuthTokenSignUpError" do
        expect { subject.create_user_from_auth_hash(auth_hash) }.to raise_error(AuthTokenSignUpError, "You have alreay registered an account. Login to link your #{auth_hash} account with your TmuxMe account")
      end
    end

    context "when the user does not already exist" do
      before { allow(User).to receive(:exists?).and_return(false) }

      it "creates a new user from the passed hash" do
        password = double
        allow(User).to receive(:generate_random_password).and_return(password)
        auth_hash = {'info' => {'nickname' => 'nickname', 'email' => 'email'}}
        expect(User).to receive(:new).with({email: 'email', username: 'nickname', password: password}).and_return(user)
        subject.create_user_from_auth_hash(auth_hash)
      end

      it "saves the new user" do
        allow(User).to receive(:new).and_return(user)
        expect(user).to receive(:save)
        subject.create_user_from_auth_hash(auth_hash)
      end

      context "when the user is saved successfully" do
        before do
          allow(User).to receive(:new).and_return(user)
          allow(user).to receive(:save).and_return(true)
        end

        it "registers a new auth token" do
          expect(subject).to receive(:register_auth_token)
          subject.create_user_from_auth_hash(auth_hash)
        end

        it "returns the user" do
          expect(subject.create_user_from_auth_hash(double.as_null_object)).to eq(user)
        end
      end

      context "when the user is not saved successfully" do
        before do
          allow(User).to receive(:new).and_return(user)
          allow(user).to receive(:save).and_return(false)
        end

        it "throws an AuthTokenSignUpError" do
          expect { subject.create_user_from_auth_hash(auth_hash) }.to raise_error(AuthTokenSignUpError, "Error encountered processing your #{auth_hash} account")
        end
      end
    end
  end

  describe "#register_auth_token" do
    it "creates a new auth token for the user" do
      auth_tokens = double('auth_tokens')
      user = double('user')
      allow(user).to receive(:auth_tokens).and_return(auth_tokens)
      expect(auth_tokens).to receive(:create)
      subject.register_auth_token(user, double.as_null_object)
    end
  end

  describe "#auth_token_hash_from" do
    let(:auth_token) { double('auth_tokens', provider: 'provider') }

    it "returns a hash indexed by provider" do
      user = double('user')
      allow(user).to receive(:auth_tokens).and_return([auth_token])
      expect(subject.auth_token_hash_from(user)).to eq({'provider' => auth_token})
    end
  end

  describe ".find_or_create_user_from_auth_hash" do
    let(:auth_hash) { OmniAuth.config.mock_auth[:github] }
    let(:user) { double('user').as_null_object }
    let(:auth_token) { double('auth_token', user: user) }
    let(:auth_tokens) { [auth_token] }

    it "looks up a user by auth token" do
      expect(AuthToken).to receive(:where).with(uid: '12345').and_return(auth_tokens)
      subject.find_or_create_user_from_auth_hash(auth_hash)
    end

    context "when the auth token is found" do
      before do
        allow(AuthToken).to receive(:where).and_return(auth_tokens)
      end

      it "returns the user from the auth token and a logged in result message" do
        expect(subject.find_or_create_user_from_auth_hash(auth_hash)).to eq(user)
      end
    end

    context "when the auth token is not found" do
      let(:new_user) { double('new_user').as_null_object }
      before do
        allow(AuthToken).to receive(:where).and_return([])
      end

      it "creates a new user from auth hash" do
        expect(subject).to receive(:create_user_from_auth_hash).with(auth_hash)
        subject.find_or_create_user_from_auth_hash(auth_hash)
      end

      it "returns the newly created user" do
        allow(subject).to receive(:create_user_from_auth_hash).and_return(new_user)
        expect(subject.find_or_create_user_from_auth_hash(auth_hash)).to eq(new_user)
      end
    end
  end
end
