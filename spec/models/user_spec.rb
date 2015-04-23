require 'rails_helper'

describe User do
  describe "#send_password_reset_email" do
    subject { User.new(:password => 'foo', :password_confirmation => 'foo') }

    it "generates a password reset token" do
      allow(subject).to receive(:save!)
      allow(UserMailer).to receive_message_chain(:password_reset, :deliver_now)
      expect(subject).to receive(:generate_password_reset_token)
      subject.send_password_reset_email
    end

    it "sets the password reset sent at to the current time" do
      allow(subject).to receive(:save!)
      cur_time = double('current time')
      allow(Time).to receive_message_chain(:zone, :now).and_return(cur_time)
      expect(subject).to receive(:password_reset_sent_at=).with(cur_time)
      allow(UserMailer).to receive_message_chain(:password_reset, :deliver_now)
      subject.send_password_reset_email
    end

    it "saves the user" do
      expect(subject).to receive(:save!)
      allow(UserMailer).to receive_message_chain(:password_reset, :deliver_now)
      subject.send_password_reset_email
    end

    it "delivers the UserMailer password reset e-mail" do
      allow(subject).to receive(:save!)
      mail = double('mail')
      expect(UserMailer).to receive(:password_reset).with(subject).and_return(mail)
      expect(mail).to receive(:deliver_now)
      subject.send_password_reset_email
    end
  end

  describe "#generate_password_reset_token" do
    it "generates a unique password reset token" do
      allow(User).to receive(:exists?).and_return(false)
      expect(SecureRandom).to receive(:urlsafe_base64)
      subject.generate_password_reset_token
    end

    it "assigns the generated password reset token" do
      token = "someuniquetokenvalue"
      allow(User).to receive(:exists?).and_return(false)
      allow(SecureRandom).to receive(:urlsafe_base64).and_return(token)
      expect(subject).to receive(:password_reset_token=).with(token)
      subject.generate_password_reset_token
    end

    it "returns the generated unique password reset token" do
      token = "anotheruniquetoken"
      allow(SecureRandom).to receive(:urlsafe_base64).and_return(token)
      expect(subject.generate_password_reset_token).to eq token
    end
  end

  describe ".create_from_auth_hash" do
    let(:user) { double('user').as_null_object }
    let(:auth_hash) { double('auth_hash').as_null_object }

    context "when the user already exists" do
      before { allow(User).to receive(:exists?).and_return(true) }

      it "throws an AuthTokenSignUpError" do
        expect { User.create_from_auth_hash(auth_hash) }.to raise_error(AuthTokenSignUpError, "You have alreay registered an account. Login to link your #{auth_hash} account with your TmuxMe account")
      end
    end

    context "when the user does not already exist" do
      before { allow(User).to receive(:exists?).and_return(false) }

      it "creates a new user from the passed hash" do
        password = double
        allow(User).to receive(:generate_random_password).and_return(password)
        auth_hash = {'info' => {'nickname' => 'nickname', 'email' => 'email'}}
        expect(User).to receive(:new).with({email: 'email', username: 'nickname', password: password}).and_return(user)
        User.create_from_auth_hash(auth_hash)
      end

      it "saves the new user" do
        allow(User).to receive(:new).and_return(user)
        expect(user).to receive(:save)
        User.create_from_auth_hash(auth_hash)
      end

      context "when the user is saved successfully" do
        before do
          allow(User).to receive(:new).and_return(user)
          allow(user).to receive(:save).and_return(true)
        end

        it "registers a new auth token" do
          expect(user).to receive(:register_auth_token)
          User.create_from_auth_hash(auth_hash)
        end

        it "returns the user" do
          expect(User.create_from_auth_hash(double.as_null_object)).to eq(user)
        end
      end

      context "when the user is not saved successfully" do
        before do
          allow(User).to receive(:new).and_return(user)
          allow(user).to receive(:save).and_return(false)
        end

        it "throws an AuthTokenSignUpError" do
          expect { User.create_from_auth_hash(auth_hash) }.to raise_error(AuthTokenSignUpError, "Error encountered processing your #{auth_hash} account")
        end
      end
    end
  end

  describe "#register_auth_token" do
    it "creates a new auth token for the user" do
      auth_tokens = double('auth_tokens')
      allow(subject).to receive(:auth_tokens).and_return(auth_tokens)
      expect(auth_tokens).to receive(:create)
      subject.register_auth_token(double.as_null_object)
    end
  end

  describe "#set_new_user" do
    context "when a user object is newly saved" do
      it "sets the new_user attribute to true" do
        user = FactoryGirl.create(:user)
        expect(user.new_user).to eq(true)
      end
    end

    context "when the user object is not newly saved" do
      it "does not set the new_user attribute" do
        id = FactoryGirl.create(:user).id
        user = User.find(id)
        expect(user.new_user).to eq(nil)
      end
    end
  end

  describe "#auth_token_hash" do
    let(:auth_token) { double('auth_tokens', provider: 'provider') }

    it "returns a hash indexed by provider" do
      allow(subject).to receive(:auth_tokens).and_return([auth_token])
      expect(subject.auth_token_hash).to eq({'provider' => auth_token})
    end
  end

  describe ".find_or_create_from_auth_hash" do
    let(:auth_hash) { OmniAuth.config.mock_auth[:github] }
    let(:user) { double('user').as_null_object }
    let(:auth_token) { double('auth_token', user: user) }
    let(:auth_tokens) { [auth_token] }

    it "looks up a user by auth token" do
      expect(AuthToken).to receive(:where).with(uid: '12345').and_return(auth_tokens)
      User.find_or_create_from_auth_hash(auth_hash)
    end

    context "when the auth token is found" do
      before do
        allow(AuthToken).to receive(:where).and_return(auth_tokens)
      end

      it "returns the user from the auth token and a logged in result message" do
        expect(User.find_or_create_from_auth_hash(auth_hash)).to eq(user)
      end
    end

    context "when the auth token is not found" do
      let(:new_user) { double('new_user').as_null_object }
      before do
        allow(AuthToken).to receive(:where).and_return([])
      end

      it "creates a new user from auth hash" do
        expect(User).to receive(:create_from_auth_hash).with(auth_hash)
        User.find_or_create_from_auth_hash(auth_hash)
      end

      it "returns the newly created user" do
        allow(User).to receive(:create_from_auth_hash).and_return(new_user)
        expect(User.find_or_create_from_auth_hash(auth_hash)).to eq(new_user)
      end
    end
  end

  describe ".generate_random_password" do
    it "calls securerandom for a new 32 bit hex string" do
      expect(SecureRandom).to receive(:hex).with(32)
      User.generate_random_password
    end
  end
end
