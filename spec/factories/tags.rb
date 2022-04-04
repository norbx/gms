# frozen_string_literal: true

FactoryBot.define do
  factory :tag do
    name { Faker::Music.genre + Faker::Number.number(digits: 10).to_s }
  end
end
