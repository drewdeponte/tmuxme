require 'spec_helper'

describe User do
  describe "#send_password_reset_email" do
    subject { User.new(:password => 'foo', :password_confirmation => 'foo') }

    it "generates a password reset token" do
      subject.stub(:save!)
      UserMailer.stub_chain(:password_reset, :deliver)
      subject.should_receive(:generate_password_reset_token)
      subject.send_password_reset_email
    end

    it "sets the password reset sent at to the current time" do
      subject.stub(:save!)
      cur_time = double('current time')
      Time.stub_chain(:zone, :now).and_return(cur_time)
      subject.should_receive(:password_reset_sent_at=).with(cur_time)
      UserMailer.stub_chain(:password_reset, :deliver)
      subject.send_password_reset_email
    end

    it "saves the user" do
      subject.should_receive(:save!)
      UserMailer.stub_chain(:password_reset, :deliver)
      subject.send_password_reset_email
    end

    it "delivers the UserMailer password reset e-mail" do
      subject.stub(:save!)
      mail = double('mail')
      UserMailer.should_receive(:password_reset).with(subject).and_return(mail)
      mail.should_receive(:deliver)
      subject.send_password_reset_email
    end
  end

  describe "#generate_password_reset_token" do
    it "generates a unique password reset token" do
      User.stub(:exists?).and_return(false)
      SecureRandom.should_receive(:urlsafe_base64)
      subject.generate_password_reset_token
    end

    it "assigns the generated password reset token" do
      token = "someuniquetokenvalue"
      User.stub(:exists?).and_return(false)
      SecureRandom.stub(:urlsafe_base64).and_return(token)
      subject.should_receive(:password_reset_token=).with(token)
      subject.generate_password_reset_token
    end

    it "returns the generated unique password reset token" do
      token = "anotheruniquetoken"
      SecureRandom.stub(:urlsafe_base64).and_return(token)
      subject.generate_password_reset_token.should == token
    end
  end

end
