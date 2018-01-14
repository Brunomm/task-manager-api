FactoryBot.define do
	factory :user do
		name     'Bruno'
		email    { Faker::Internet.email }
		password '123456789'
		password_confirmation '123456789'
	end
end