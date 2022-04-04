# frozen_string_literal: true

FactoryBot.define do
  factory :band do
    name { Faker::Book.unique.title }
    contact_name { 'Some contact' }
    phone_number { '+1 011 233 11' }
    description { 'Some verbose description of how fancy this band is.' }
    social_links { 'twitter.com/someband, facebook.com/someband' }

    tags { create_list(:tag, 1) }
    images do
      [
        Rack::Test::UploadedFile.new(Rails.root.join('spec/', 'fixtures/', 'images/', 'band.jpg'), 'image/jpeg',
                                     true),
        Rack::Test::UploadedFile.new(Rails.root.join('spec/', 'fixtures/', 'images/', 'band2.jpg'), 'image/jpeg', true)
      ]
    end
  end
end
