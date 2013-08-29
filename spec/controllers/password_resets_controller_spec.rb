require 'spec_helper'

describe PasswordResetsController do
  describe "GET #new" do
    it "renders the new password reset template" do
      get :new
      controller.should render_template('new')
    end
  end

  describe "POST #create" do
    it "check if the given e-mail address matches an existing user" do
      User.should_receive(:find_by_email).with('some@example.com')
      post :create, :email => 'some@example.com'
    end

    context "given e-mail matches a user" do

      before(:each) do
        @user = double('matching user')
        User.stub(:find_by_email).and_return(@user)
      end

      it "send the password reset e-mail to the users e-mail address" do
        @user.should_receive(:send_password_reset_email)
        post :create, :email => 'some@example.com'
      end

      it "renders the create template notifying the user password reset instructions have been sent" do
        @user.stub(:send_password_reset_email)
        post :create, :email => 'some@example.com'
        controller.should render_template('create')
      end
    end

    context "given e-mail does NOT match a user" do

      before(:each) do
        User.stub(:find_by_email).and_return(nil)
      end

      it "sets the flash notice with a message stating unknown e-mail address" do
        flash_now_hash = double('flash now hash')
        flash_now_hash.should_receive(:[]=).with(:error, "Unrecognized e-mail address!")
        controller.stub_chain(:flash, :now).and_return(flash_now_hash)
        post :create, :email => 'aeouaoeuaoeuaoe@example.com'
      end

      it "re-renders the new template" do
        post :create, :email => 'aaoeuaoeuaoeu@example.com'
        controller.should render_template('new')
      end
    end
  end

  describe "GET #edit" do
    it "finds user matching the given password reset token" do
      User.should_receive(:find_by_password_reset_token!).with('myresettoken')
      get :edit, :id => 'myresettoken'
    end

    context "given password reset token matches a user" do
      before(:each) do
        User.stub(:find_by_password_reset_token!).and_return(double('user'))
      end

      it "renders the edit template" do
        get :edit, :id => 'myresettoken'
        controller.should render_template('edit')
      end
    end
  end

  describe "PUT #update" do
    it "finds user matching the given password reset token" do
      User.should_receive(:find_by_password_reset_token!).with('myresettoken').and_return(double('user', :password_reset_sent_at => Time.now - 6.hours))
      put :update, :id => 'myresettoken'
    end

    context "password reset sent more than 2 hours ago" do
      before(:each) do
        User.stub(:find_by_password_reset_token!).and_return(double('user', :password_reset_sent_at => Time.now - 6.hours))
      end

      it "redirects to the new password reset path" do
        put :update, :id => 'myresettoken'
        controller.should redirect_to(new_password_reset_path)
      end
    end

    context "password reset sent less than 2 hours ago" do
      let(:user) { double('user', :password_reset_sent_at => Time.now - 1.hour) }

      it "updates the user attributes with the new passwords" do
        User.stub(:find_by_password_reset_token!).and_return(user)
        user.should_receive(:update_attributes).with({ 'password' => 'foo', 'password_confirmation' => 'foo' }).and_return(true)
        put :update, :id => 'myresettoken', :user => { :password => 'foo', :password_confirmation => 'foo' }
      end

      it "redirects to root url if updating the user attributes succeeds" do
        User.stub(:find_by_password_reset_token!).and_return(user)
        user.stub(:update_attributes).and_return(true)
        put :update, :id => 'myresettoken', :user => {:password => 'somepassword', :password_confirmation => 'somepassword'} 
        controller.should redirect_to(root_path)
      end

      it "renders edit template if updating the user attributes fails" do
        User.stub(:find_by_password_reset_token!).and_return(user)
        user.stub(:update_attributes).and_return(false)
        put :update, :id => 'myresettoken', :user => {:password => 'somepassword', :password_confirmation => 'somepassword'} 
        controller.should render_template('edit')
      end
    end
  end
end
