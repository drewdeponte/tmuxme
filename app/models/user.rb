class User < ActiveRecord::Base
  has_secure_password
  validates_uniqueness_of :email
  validates_uniqueness_of :username

  has_many :public_keys
  has_many :auth_tokens

  def self.create_from_auth_hash(auth_hash)
    user = User.new(email: auth_hash['info']['email'], username: auth_hash['info']['nickname'], password: generate_random_password)
    if user.save
      user.auth_tokens.create(
        uid: auth_hash['uid'],
        provider: auth_hash['provider'],
        info: auth_hash['info'],
        credentials: auth_hash['credentials'],
        extra: auth_hash['extra']
      )
    end

    return user
  end

  def self.find_or_create_from_auth_hash(auth_hash)
    auth_token = AuthToken.where(uid: auth_hash['uid']).first
    if auth_token.nil?
      user = create_from_auth_hash(auth_hash)
    else
      user = auth_token.user
    end

    return user
  end

  def send_password_reset_email
    self.generate_password_reset_token
    self.password_reset_sent_at = Time.zone.now
    self.save!
    UserMailer.password_reset(self).deliver_now
  end

  def generate_password_reset_token
    begin
      self.password_reset_token = SecureRandom.urlsafe_base64
    end while User.exists?(:password_reset_token => self.password_reset_token)
    return self.password_reset_token
  end

  def self.generate_random_password
    SecureRandom.hex(32)
  end
end
