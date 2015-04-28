class AuthToken < ActiveRecord::Base
  belongs_to :user

  SUPPORTED_PROVIDERS = %w{github}
end
