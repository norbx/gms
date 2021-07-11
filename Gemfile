# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

gem 'bcrypt', '~> 3.1', '>= 3.1.16'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'devise', '~> 4.8'
gem 'devise-jwt', '~> 0.8.1'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'rails', '~> 6.1.3', '>= 6.1.3.2'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  gem 'listen', '~> 3.3'
  gem 'spring'
end

group :development, :test do
  gem 'dotenv-rails', '~> 2.7', '>= 2.7.6', require: 'dotenv/rails-now'
  gem 'factory_bot', '~> 6.2'
  gem 'pry', '~> 0.14.1'
  gem 'rspec-rails', '~> 5.0', '>= 5.0.1'
  gem 'rubocop', '~> 1.14'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
