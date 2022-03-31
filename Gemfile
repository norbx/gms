# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

gem 'active_model_serializers', '~> 0.10.13'
gem 'aws-sdk-s3', '~> 1.113'
gem 'bcrypt', '~> 3.1', '>= 3.1.16'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'cloudinary', '~> 1.22'
gem 'dotenv-rails', '~> 2.7', '>= 2.7.6'
gem 'image_processing', '~> 1.12', '>= 1.12.2'
gem 'jwt', '~> 2.3'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'rack-cors', '~> 1.1', '>= 1.1.1'
gem 'rails', '~> 6.1.3', '>= 6.1.3.2'

group :development do
  gem 'listen', '~> 3.3'
  gem 'spring'
end

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails', '~> 6.2'
  gem 'faker', '~> 2.20'
  gem 'pry', '~> 0.14.1'
  gem 'rspec-rails', '~> 5.0', '>= 5.0.1'
  gem 'rubocop', '~> 1.14'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
