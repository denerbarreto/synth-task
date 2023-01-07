class User < ApplicationRecord
  has_secure_password

  validates :password, length: { minimum: 8, maximum: 20 }, presence: true
  validates :password_digest, presence: true
  validates :name, presence: true, length: { minimum: 3, maximum: 50 }
  validates :email, presence: true, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }

  def generate_auth_token
    expiry = Time.now + 7.days
    payload = { user_id: id, username: name, expiry: expiry }
    token = JWT.encode(payload, Rails.application.secrets.secret_key_base, 'HS256')

    self.tokens << token
    save
    return token
  end

  def self.authenticate(token)
    begin
      payload = JWT.decode(token, Rails.application.secrets.secret_key_base, true, { algorithm: 'HS256' })[0]
      user_id = payload['user_id']
      user = find(user_id)
      if user && Time.now < payload['expiry']
        user
      else
        nil
      end
    rescue JWT::DecodeError
      nil
    end
  end  
end
