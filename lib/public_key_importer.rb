class PublicKeyImporter
  def self.import_github_keys(user)
    auth_token = user.auth_tokens.where(provider: 'github').first
    if auth_token.present?
      keys = GithubClient.keys(auth_token)
      keys.each do |key|
        user.public_keys.create(name: key["title"], value: key["key"])
      end
    end
  end
end
