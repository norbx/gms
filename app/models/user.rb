# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_one_attached :avatar

  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, if: :password
  validates :avatar, content_type: %i[png jpg jpeg],
                     size: { less_than: 5.megabytes, message: 'file size should be lesser than 5mb' }

  has_and_belongs_to_many :bands

  def token
    JwtToken.generate_token(self)
  end
end
