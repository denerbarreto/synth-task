class User < ApplicationRecord
  has_secure_password

  validates :password, length: { minimum: 8, maximum: 20 }, presence: true
  validates :password_digest, presence: true
  validates :name, presence: true, length: { minimum: 3, maximum: 50 }
  validates :email, presence: true, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
end
