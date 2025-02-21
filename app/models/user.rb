class User < ApplicationRecord
  has_secure_password
  has_secure_token :auth_token
  has_many :posts
  has_many :post_entries

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :uuid, presence: true, uniqueness: true
  validates :nickname, presence: true, uniqueness: true,
    format: { with: /\A[a-z0-9]+\z/, message: "only allows lowercase letters and numbers" }

  before_create :ensure_uuid

  private

  def ensure_uuid
    self.uuid ||= SecureRandom.uuid
  end
end
