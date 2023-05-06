# frozen_string_literal: true

User.destroy_all
Tag.destroy_all
Band.destroy_all

diego = User.create(name: 'Diego', email: 'diego@mail.com', password_digest: BCrypt::Password.create("password"))
ronnie = User.create(name: 'Ronnie', email: 'ronnie@mail.com', password_digest: BCrypt::Password.create("password"))

Band.create(
  name: "The Bongos",
  active: true,
  contact_name: "Sir Gregor Clegane",
  phone_number: "123456789",
  description: "Kings of the bonks!",
  social_links: { facebook: "www.facebook.com/thebongos" },
  users: [diego],
  tags: [Tag.create(name: "Disco"), Tag.create(name: "Wedding")]
)

Band.create(
  name: "The Stonks",
  active: true,
  contact_name: "Sir Jorah Mormont",
  phone_number: "987654321",
  description: "We are The Stonks :)",
  social_links: { twitter: "www.twitter.com/thestonks" },
  users: [ronnie],
  tags: [Tag.create(name: "Brit Pop"), Tag.create(name: "Rock")]
)
