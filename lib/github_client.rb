class GithubClient
  def self.keys(auth_token)
    keys = Github::Client::Users::Keys.new
    keys.list auth_token.info["nickname"], oauth_token: auth_token.credentials["token"]
  end
end
