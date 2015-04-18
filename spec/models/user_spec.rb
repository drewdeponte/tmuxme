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

  describe ".create_from_auth_token" do
    let(:user) { double('user').as_null_object }

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
      User.create_from_auth_hash(double.as_null_object)
    end

    context "when the user is saved successfully" do
      before do
        allow(User).to receive(:new).and_return(user)
      end

      it "creates a new auth token" do
        auth_tokens = double('auth_tokens')
        allow(user).to receive(:auth_tokens).and_return(auth_tokens)
        expect(auth_tokens).to receive(:create)
        User.create_from_auth_hash(double.as_null_object)
      end
    end

    it "returns the user" do
      allow(User).to receive(:new).and_return(user)
      expect(User.create_from_auth_hash(double.as_null_object)).to eq(user)
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

      it "returns the user from the auth token" do
        expect(User.find_or_create_from_auth_hash(auth_hash)).to eq(user)
      end
    end

    context "when the auth token is not found" do
      before do
        allow(AuthToken).to receive(:where).and_return([])
      end

      it "creates a new user from auth hash" do
        expect(User).to receive(:create_from_auth_hash).with(auth_hash)
        User.find_or_create_from_auth_hash(auth_hash)
      end

      it "returns the newly created user" do
        new_user = double('new_user')
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
