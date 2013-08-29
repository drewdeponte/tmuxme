require 'spec_helper'

describe ApplicationController do
  let (:user_id) { double }

  describe "#current_user" do
    context "when a the session variable user_id is present" do
      before do
        subject.session[:user_id] = user_id 
      end

      it "fetches the user object" do
        User.should_receive(:find).with(user_id)
        subject.send(:current_user)
      end

      it "returns the fetched user object" do
        user = double
        User.stub(:find).and_return(user)
        subject.send(:current_user).should == user
      end
    end

    context "when a session variable user_id is not present" do
      it "returns a nil" do
        subject.send(:current_user).should be_nil
      end
    end
  end

  describe "#authenticate!" do
    context "when there is no user session" do
      it "redirects to the get started page" do
        subject.should_receive(:redirect_to).with(new_session_path)
        subject.send(:authenticate!)
      end

      it "returns false" do
        subject.stub(:redirect_to)
        subject.send(:authenticate!).should be_false
      end
    end

    context "when there is a user session" do
      before do
        User.stub(:find).and_return(double)
        subject.session[:user_id] = user_id
      end

      it "returns true" do
        subject.send(:authenticate!).should be_true
      end
    end
  end
end
