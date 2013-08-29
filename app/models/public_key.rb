class PublicKey < ActiveRecord::Base
  has_one :user
end
