FactoryBot.define do
  factory :task do
    user        { build(:user) }
    title       { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    deadline    { Faker::Date.forward  }
    done        false
  end
end