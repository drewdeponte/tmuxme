require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "builds a user object for the view" do
      User.should_receive(:new)
      get :new
    end

    it "assign the built user object to share it with the view" do
      user = double
      User.stub(:new).and_return(user)
      get :new
      assigns[:user].should eq(user)
    end
  end

  describe "POST create" do
    let(:user_attributes) { FactoryGirl.attributes_for(:user) }

    it "builds a new user from the passed user attributes" do
      User.should_receive(:new).with(user_attributes.stringify_keys).and_return(double.as_null_object)
      post :create, :user => user_attributes 
    end

    it "saves the built user object" do
      built_user = double
      User.stub(:new).and_return(built_user)
      built_user.should_receive(:save)
      post :create, :user => user_attributes 
    end

    context "when successfully saved the user object" do
      before do
        built_user = double(:id => 'the id, duh')
        built_user.stub(:save).and_return(true)
        User.stub(:new).and_return(built_user)
      end

      it "stores the user id in the session" do
        post :create, :user => user_attributes 
        session[:user_id].should eq('the id, duh')
      end
    end

    context "when failed to save the user object" do
      before do
        built_user = double
        built_user.stub(:save).and_return(false)
        User.stub(:new).and_return(built_user)
      end

      it "renders the new template" do
        post :create, :user => user_attributes
        response.should render_template('new')
      end
    end
  end
end
