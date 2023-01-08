class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :tokens, :reset_password_tokens
end
