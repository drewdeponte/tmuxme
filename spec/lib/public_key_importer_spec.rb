require 'rails_helper'

describe PublicKeyImporter do
  subject { PublicKeyImporter }

  describe '.import_github_keys' do
    let(:auth_tokens) { double('auth_tokens') }
    let(:user) { double('user') }

    it "finds the github auth token for the passed user" do
      allow(user).to receive(:auth_tokens).and_return(auth_tokens)
      expect(auth_tokens).to receive(:where).with(provider: 'github').and_return([])
      subject.import_github_keys(user)
    end

    context "when auth token is present" do
      let(:auth_token) { double('auth_token') }

      before do
        allow(user).to receive(:auth_tokens).and_return(auth_tokens)
        allow(auth_tokens).to receive(:where).with(provider: 'github').and_return([auth_token])
      end

      it "fetchs keys from github" do
        expect(GithubClient).to receive(:keys).with(auth_token).and_return([])
        subject.import_github_keys(user)
      end

      it "adds each to to the user's public keys" do
        key = {"title" => "title", "key" => "key"}
        public_keys = double('public_keys')
        allow(GithubClient).to receive(:keys).and_return([key])
        allow(user).to receive(:public_keys).and_return(public_keys)
        expect(public_keys).to receive(:create).with(name: "title", value: "key")
        subject.import_github_keys(user)
      end

    end
  end
end
