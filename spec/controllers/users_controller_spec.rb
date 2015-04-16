require 'rails_helper'

describe UsersController do
  describe "GET new" do
    it "builds a user object for the view" do
      expect(User).to receive(:new)
      get :new
    end

    it "assign the built user object to share it with the view" do
      user = double
      allow(User).to receive(:new).and_return(user)
      get :new
      expect(assigns[:user]).to eq(user)
    end
  end

  describe "POST create" do
    let(:user_attributes) { FactoryGirl.attributes_for(:user) }

    it "builds a new user from the passed user attributes" do
      expect(User).to receive(:new).with(user_attributes.stringify_keys).and_return(double.as_null_object)
      post :create, :user => user_attributes
    end

    it "saves the built user object" do
      built_user = double
      allow(User).to receive(:new).and_return(built_user)
      expect(built_user).to receive(:save)
      post :create, :user => user_attributes
    end

    context "when successfully saved the user object" do
      before do
        built_user = double(:id => 'the id, duh')
        allow(built_user).to receive(:save).and_return(true)
        allow(User).to receive(:new).and_return(built_user)
      end

      it "stores the user id in the session" do
        post :create, :user => user_attributes
        expect(session[:user_id]).to eq('the id, duh')
      end
    end

    context "when failed to save the user object" do
      before do
        built_user = double
        allow(built_user).to receive(:save).and_return(false)
        allow(User).to receive(:new).and_return(built_user)
      end

      it "renders the new template" do
        post :create, :user => user_attributes
        expect(response).to render_template('new')
      end
    end
  end
end
