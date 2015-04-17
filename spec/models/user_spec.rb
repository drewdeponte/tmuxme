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
end
