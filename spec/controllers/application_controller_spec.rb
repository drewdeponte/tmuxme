require 'rails_helper'

describe ApplicationController do
  let (:user_id) { double }

  describe "#current_user" do
    context "when a the session variable user_id is present" do
      before do
        subject.session[:user_id] = user_id
      end

      it "fetches the user object" do
        expect(User).to receive(:find).with(user_id)
        subject.send(:current_user)
      end

      it "returns the fetched user object" do
        user = double
        allow(User).to receive(:find).and_return(user)
        expect(subject.send(:current_user)).to eq user
      end
    end

    context "when a session variable user_id is not present" do
      it "returns a nil" do
        expect(subject.send(:current_user)).to be_nil
      end
    end
  end

  describe "#authenticate!" do
    context "when there is no user session" do
      it "redirects to the get started page" do
        expect(subject).to receive(:redirect_to).with(new_session_path)
        subject.send(:authenticate!)
      end

      it "returns false" do
        allow(subject).to receive(:redirect_to)
        expect(subject.send(:authenticate!)).to eq(false)
      end
    end

    context "when there is a user session" do
      before do
        allow(User).to receive(:find).and_return(double)
        subject.session[:user_id] = user_id
      end

      it "returns true" do
        expect(subject.send(:authenticate!)).to eq(true)
      end
    end
  end
end
