require 'spec_helper'

describe PublicKeysController do
  context "when user is NOT logged in" do
    before do
      allow(controller).to receive(:current_user)
    end

    it "redirects to the login path" do
      get :index
      expect(response).to redirect_to(new_session_path)
    end
  end

  describe "GET index" do
    context "when user is logged in" do
      let(:current_user_mock) { double('current user') }

      before do
        allow(controller).to receive(:current_user).and_return(current_user_mock)
      end

      it "gets all the users public keys" do
        expect(current_user_mock).to receive(:public_keys)
        get :index
      end

      it "assigns the public keys" do
        public_keys_stub = double('public keys')
        allow(current_user_mock).to receive(:public_keys).and_return(public_keys_stub)
        get :index
        expect(assigns(:public_keys)).to eq(public_keys_stub)
      end

      it "renders the index template" do
        allow(current_user_mock).to receive(:public_keys)
        get :index
        expect(response).to render_template('index')
      end
    end

  end

  describe "GET new" do
    context "when user is logged in" do
      let(:current_user_mock) { double('current user') }

      before do
        allow(controller).to receive(:current_user).and_return(current_user_mock)
      end

      it "assigns a new public key" do
        public_key_stub = double('public key')
        allow(PublicKey).to receive(:new).and_return(public_key_stub)
        get :new
        expect(assigns(:public_key)).to eq(public_key_stub)
      end

      it "renders the new template" do
        get :new
        expect(response).to render_template('new')
      end
    end
  end

  describe "POST create" do
    context "when user is logged in" do
      let(:current_user_mock) { double('current user') }

      before do
        allow(controller).to receive(:current_user).and_return(current_user_mock)
      end

      it "builds a public key associated with the logged in user" do
        public_keys_mock = double('public keys arel obj')
        allow(current_user_mock).to receive(:public_keys).and_return(public_keys_mock)
        expect(public_keys_mock).to receive(:new).with(name: 'my key blue', value: 'my key blues value').and_return(double.as_null_object)
        post :create, public_key: { name: 'my key blue', value: 'my key blues value' }
      end

      it "saves the previously built public key" do
        public_key_mock = double('public key')
        public_keys_stub = double('public keys arel obj', new: public_key_mock)
        allow(current_user_mock).to receive(:public_keys).and_return(public_keys_stub)
        expect(public_key_mock).to receive(:save).and_return(true)
        post :create, public_key: { name: 'my key blue', value: 'my key blues value' }
      end

      context "when it successfully saves the public key" do
        it "regenerates and writes the authorized keys file" do
          public_key_mock = double('public key', save: true)
          public_keys_mock = double('public keys arel obj')
          allow(current_user_mock).to receive(:public_keys).and_return(public_keys_mock)
          allow(public_keys_mock).to receive(:new).and_return(public_key_mock)
          expect(AuthorizedKeysGenerator).to receive(:generate_and_write)
          post :create, public_key: { name: 'my key blue', value: 'my key blues value' }
        end

        it "redirects to the list public keys page" do
          public_key_mock = double('public key', save: true)
          public_keys_mock = double('public keys arel obj').as_null_object
          allow(current_user_mock).to receive(:public_keys).and_return(public_keys_mock)
          allow(public_keys_mock).to receive(:new).and_return(public_key_mock)
          post :create, public_key: { name: 'my key blue', value: 'my key blues value' }
          expect(response).to redirect_to(public_keys_path)
        end
      end

      context "when it failes to save the public key" do
        it "sets the flash now error message" do
          public_key_mock = double('public key', save: false, errors: double(messages: { value: ['Invalid public key format.'] }, empty?: false))
          public_keys_mock = double('public keys arel obj').as_null_object
          allow(current_user_mock).to receive(:public_keys).and_return(public_keys_mock)
          allow(public_keys_mock).to receive(:new).and_return(public_key_mock)
          post :create, public_key: { name: 'my key blue', value: 'my key blues value' }
          expect(flash[:now]).to eq('Invalid public key format.')
        end

        it "renders the new template" do
          public_key_mock = double('public key', save: false, errors: [])
          public_keys_mock = double('public keys arel obj').as_null_object
          allow(current_user_mock).to receive(:public_keys).and_return(public_keys_mock)
          allow(public_keys_mock).to receive(:new).and_return(public_key_mock)
          post :create, public_key: { name: 'my key blue', value: 'my key blues value' }
          expect(response).to render_template('new')
        end
      end
    end
  end

  describe "DELETE destroy" do
    context "when user is logged in" do
      let(:current_user_mock) { double('current user') }

      before do
        allow(controller).to receive(:current_user).and_return(current_user_mock)
      end

      it "finds the key with the given id" do
        public_keys_stub = double('public keys')
        allow(current_user_mock).to receive(:public_keys).and_return(public_keys_stub)
        public_key_stub = double('public key', destroy: nil)
        expect(public_keys_stub).to receive(:find_by_id).and_return(public_key_stub)
        delete :destroy, id: 2343
      end

      context "when finds the specified key" do
        let(:public_key_stub) { double('public key', destroy: nil) }

        before do
          controller.stub_chain(:current_user, :public_keys, :find_by_id).and_return(public_key_stub)
        end

        it "deletes the public key" do
          expect(public_key_stub).to receive(:destroy)
          delete :destroy, id: 2343
        end

        it "regenerates and writes the authorized keys file" do
          expect(AuthorizedKeysGenerator).to receive(:generate_and_write)
          delete :destroy, id: 2343
        end

        it "redirects to the list public keys page" do
          delete :destroy, id: 2343
          expect(response).to redirect_to(public_keys_path)
        end
      end

      context "when does NOT find the specified key" do
        before do
          controller.stub_chain(:current_user, :public_keys, :find_by_id).and_return(nil)
        end

        it "redirects to the list public keys page" do
          delete :destroy, id: 2343
          expect(response).to redirect_to(public_keys_path)
        end
      end

    end
  end
end
