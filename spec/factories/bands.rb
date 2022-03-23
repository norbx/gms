# frozen_string_literal: true

FactoryBot.define do
  factory :band do
    name { Faker::Book.unique.title }
    contact_name { 'Some contact' }
    phone_number { '+1 011 233 11' }
    description { 'Some verbose description of how fancy this band is.' }
    social_links { 'twitter.com/someband, facebook.com/someband' }
  end
end
