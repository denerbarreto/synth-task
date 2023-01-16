FactoryBot.define do
  factory :task do
    name { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    date_start { Faker::Date.forward(days: 1) }
    date_end { Faker::Date.forward(days: 10) }
    status { ["Em andamento", "Concluída", "Atrasada", "Cancelada"].sample }
    priority { Faker::Number.between(from: 1, to: 10) }
    association :user, factory: :user
    association :task_list, factory: :task_list
  end
end
