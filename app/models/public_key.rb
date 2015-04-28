class PublicKey < ActiveRecord::Base
  has_one :user
  validates :value,
    uniqueness: { scope: :user_id },
    format: { with: /\A(?:ssh\-rsa|ssh\-dss) +(?:.+?)( +(?:.+) )?\z/, message: "Invalid public key format." }
end
