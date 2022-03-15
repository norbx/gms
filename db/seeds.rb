# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.find_or_create_by!(name: 'Diego', email: 'diego@mail.com', password_digest: BCrypt::Password.create('password'))
User.find_or_create_by!(name: 'Ronnie', email: 'ronnie@mail.com', password_digest: BCrypt::Password.create('password'))
