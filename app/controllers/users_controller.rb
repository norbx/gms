# frozen_string_literal: true

class UsersController < ApplicationController
  def create
    user = User.new(user_params)

    if user.save
      token = JwtToken.generate_token(user)

      render json: { token: token }, status: :created
    else
      render json: user.errors.messages, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :email, :first_name, :last_name)
  end
end
