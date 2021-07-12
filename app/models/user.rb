class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, uniqueness: true, presence: true
  validates :email, uniqueness: true, presence: true

  def generate_jwt
    JWT.encode({id: id, exp: 14.days.from_now.to_i}, ENV['DEVISE_SECRET_KEY'])
  end
end
