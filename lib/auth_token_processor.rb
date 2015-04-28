class AuthTokenProcessor
  def self.create_user_from_auth_hash(auth_hash)
    if User.exists?(email: auth_hash['info']['email'])
      raise AuthTokenSignUpError.new("You have alreay registered an account. Login to link your #{auth_hash['provider'].titlecase} account with your TmuxMe account")
    else
      user = User.new(email: auth_hash['info']['email'], username: auth_hash['info']['nickname'], password: User.generate_random_password)
      if user.save
        register_auth_token(user, auth_hash)
      else
        raise AuthTokenSignUpError.new("Error encountered processing your #{auth_hash['provider'].titlecase} account")
      end
    end

    return user
  end

  def self.register_auth_token(user, auth_hash)
    user.auth_tokens.create(
      uid: auth_hash['uid'],
      provider: auth_hash['provider'],
      info: auth_hash['info'],
      credentials: auth_hash['credentials'],
      extra: auth_hash['extra']
    )
  end

  def self.find_or_create_user_from_auth_hash(auth_hash)
    auth_token = AuthToken.where(uid: auth_hash['uid']).first
    if auth_token.nil?
      user = create_user_from_auth_hash(auth_hash)
    else
      user = auth_token.user
    end

    return user
  end

  def self.auth_token_hash_from(user)
    user.auth_tokens.inject({}) do |hsh, token|
      hsh[token.provider] = token
      hsh
    end
  end
end

class AuthTokenSignUpError < StandardError; end
