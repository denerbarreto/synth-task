FactoryBot.define do
  factory :project do
    name { Faker::Name.name }
    association :user, factory: :user
  end
end
