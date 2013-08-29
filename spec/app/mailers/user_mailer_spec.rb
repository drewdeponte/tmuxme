require 'spec_helper'

describe UserMailer do
  describe "#password_reset" do
    let(:user) { double('user', :email => 'bob@example.com', :password_reset_token => 'sometoken' ) }
    let(:mail) { UserMailer.password_reset(user) }

    it "sets the to field to the users e-mail address" do
      mail.to.should == [user.email]
    end

    it "sets the from field to noreply@tmux.me" do
      mail.from.should == ['noreply@tmux.me']
    end

    it "sets the subject to 'Password Reset'" do
      mail.subject == 'Password Reset'
    end
  end
end
