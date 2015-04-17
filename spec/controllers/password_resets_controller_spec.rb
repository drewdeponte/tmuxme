require 'rails_helper'

describe PasswordResetsController do
  describe "GET #new" do
    it "renders the new password reset template" do
      get :new
      expect(controller).to render_template('new')
    end
  end

  describe "POST #create" do
    it "check if the given e-mail address matches an existing user" do
      expect(User).to receive(:find_by_email).with('some@example.com')
      post :create, :email => 'some@example.com'
    end

    context "given e-mail matches a user" do

      before(:each) do
        @user = double('matching user')
        allow(User).to receive(:find_by_email).and_return(@user)
      end

      it "send the password reset e-mail to the users e-mail address" do
        expect(@user).to receive(:send_password_reset_email)
        post :create, :email => 'some@example.com'
      end

      it "renders the create template notifying the user password reset instructions have been sent" do
        expect(@user).to receive(:send_password_reset_email)
        post :create, :email => 'some@example.com'
        expect(controller).to render_template('create')
      end
    end

    context "given e-mail does NOT match a user" do

      before(:each) do
        allow(User).to receive(:find_by_email).and_return(nil)
      end

      it "sets the flash notice with a message stating unknown e-mail address" do
        flash_now_hash = double('flash now hash')
        expect(flash_now_hash).to receive(:[]=).with(:error, "Unrecognized e-mail address!")
        allow(controller).to receive_message_chain(:flash, :now).and_return(flash_now_hash)
        post :create, :email => 'aeouaoeuaoeuaoe@example.com'
      end

      it "re-renders the new template" do
        post :create, :email => 'aaoeuaoeuaoeu@example.com'
        expect(controller).to render_template('new')
      end
    end
  end

  describe "GET #edit" do
    it "finds user matching the given password reset token" do
      expect(User).to receive(:find_by_password_reset_token!).with('myresettoken')
      get :edit, :id => 'myresettoken'
    end

    context "given password reset token matches a user" do
      before(:each) do
        allow(User).to receive(:find_by_password_reset_token!).and_return(double('user'))
      end

      it "renders the edit template" do
        get :edit, :id => 'myresettoken'
        expect(controller).to render_template('edit')
      end
    end
  end

  describe "PUT #update" do
    it "finds user matching the given password reset token" do
      expect(User).to receive(:find_by_password_reset_token!).with('myresettoken').and_return(double('user', :password_reset_sent_at => Time.now - 6.hours))
      put :update, :id => 'myresettoken'
    end

    context "password reset sent more than 2 hours ago" do
      before(:each) do
        allow(User).to receive(:find_by_password_reset_token!).and_return(double('user', :password_reset_sent_at => Time.now - 6.hours))
      end

      it "redirects to the new password reset path" do
        put :update, :id => 'myresettoken'
        expect(controller).to redirect_to(new_password_reset_path)
      end
    end

    context "password reset sent less than 2 hours ago" do
      let(:user) { double('user', :password_reset_sent_at => Time.now - 1.hour) }

      it "updates the user attributes with the new passwords" do
        allow(User).to receive(:find_by_password_reset_token!).and_return(user)
        expect(user).to receive(:update_attributes).with({ 'password' => 'foo', 'password_confirmation' => 'foo' }).and_return(true)
        put :update, :id => 'myresettoken', :user => { :password => 'foo', :password_confirmation => 'foo' }
      end

      it "redirects to root url if updating the user attributes succeeds" do
        allow(User).to receive(:find_by_password_reset_token!).and_return(user)
        allow(user).to receive(:update_attributes).and_return(true)
        put :update, :id => 'myresettoken', :user => {:password => 'somepassword', :password_confirmation => 'somepassword'}
        expect(controller).to redirect_to(new_session_path)
      end

      it "renders edit template if updating the user attributes fails" do
        allow(User).to receive(:find_by_password_reset_token!).and_return(user)
        allow(user).to receive(:update_attributes).and_return(false)
        put :update, :id => 'myresettoken', :user => {:password => 'somepassword', :password_confirmation => 'somepassword'}
        expect(controller).to render_template('edit')
      end
    end
  end
end
