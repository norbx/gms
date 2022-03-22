# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.unique.first_name }
    email { Faker::Internet.unique.email }
    first_name { 'Ayrton' }
    last_name { 'Senna' }
    password { 'xyzabc' }
  end
end
