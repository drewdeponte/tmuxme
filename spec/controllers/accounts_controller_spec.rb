require 'rails_helper'

describe AccountsController do
  let(:current_user) { double('current user') }

  before do
    allow(controller).to receive(:current_user).and_return(current_user)
  end

  describe "GET edit" do
    it "assigns current_user to @user" do
      get :edit
      expect(assigns[:user]).to eq(current_user)
    end
  end

  describe "PUT update" do
    it "updates the current_user with the passed user attributes" do
      expect(current_user).to receive(:update).with({ email: "test@email.com" })
      put :update, {user: { email: "test@email.com" } }
    end

    context "when update is successful" do
      before { allow(current_user).to receive(:update).and_return(true) }

      it "sets the flash to update successful" do
        put :update, {user: { email: "test@email.com" } }
        expect(flash[:success]).to eq("Update Successful")
      end

      it "redirects to the account path" do
        put :update, {user: { email: "test@email.com" } }
        expect(response).to redirect_to(account_path)
      end
    end

    context "when update is not successful" do
      before { allow(current_user).to receive(:update).and_return(false) }

      it "renders the edit page" do
        put :update, {user: { email: "test@email.com" } }
        expect(response).to render_template(:edit)
      end
    end
  end
end
