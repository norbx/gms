# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    username { 'ayrton' }
    email { 'ayrtonsenna@mail.com' }
    first_name { 'Ayrton' }
    last_name { 'Senna' }
    password { 'xyzabc' }
  end
end