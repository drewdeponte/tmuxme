class User < ActiveRecord::Base
  has_secure_password
  validates_uniqueness_of :email

  def send_password_reset_email
    self.generate_password_reset_token
    self.password_reset_sent_at = Time.zone.now
    self.save!
    UserMailer.password_reset(self).deliver
  end

  def generate_password_reset_token
    begin
      self.password_reset_token = SecureRandom.urlsafe_base64
    end while User.exists?(:password_reset_token => self.password_reset_token)
    return self.password_reset_token
  end

end
