FactoryBot.define do
  factory :task_list do
    name { Faker::Name.name }
    order { Faker::Number.digit }
    association :user, factory: :user
    association :project, factory: :project
  end
end
