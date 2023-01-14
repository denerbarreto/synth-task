FactoryBot.define do
  factory :task_list do
    name { Faker::Name.name }
    association :user, factory: :user
    order { Faker::Number.digit }
  end
end
