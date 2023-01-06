FactoryBot.define do
  factory :user do
    name { "MyString" }
    email { "MyString" }
    password_digest { "MyString" }
    tokens { "" }
    reset_password_tokens { "" }
  end
end
