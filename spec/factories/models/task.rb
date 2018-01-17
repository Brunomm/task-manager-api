FactoryBot.define do
  factory :task do
    association :user
    title       { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    deadline    { Faker::Date.forward  }
    done        false
  end
end