class User < ActiveRecord::Base
  has_secure_password
  validates_uniqueness_of :email
  validates_uniqueness_of :username

  has_many :public_keys
  has_many :auth_tokens

  attr_reader :new_user
  after_create :set_new_user
  def set_new_user
    @new_user = true
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

