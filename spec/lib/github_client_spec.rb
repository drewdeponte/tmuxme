require 'rails_helper'

describe GithubClient do
  describe ".keys" do
    let(:client) { double('client').as_null_object }

    it "creates a new github keys client" do
      expect(Github::Client::Users::Keys).to receive(:new).and_return(client)
      GithubClient.keys(double.as_null_object)
    end

    it "fetchs the list of keys from the client" do
      auth_token = double('auth_token', info: {'nickname' => 'nickname'}, credentials: {'token' => 'token'})
      allow(Github::Client::Users::Keys).to receive(:new).and_return(client)
      expect(client).to receive(:list).with('nickname', oauth_token: 'token')
      GithubClient.keys(auth_token)
    end
  end
end
