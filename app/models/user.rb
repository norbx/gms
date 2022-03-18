# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, if: :password

  has_and_belongs_to_many :bands
  has_one_attached :avatar

  def token
    JwtToken.generate_token(self)
  end
end
