# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :authenticate, only: :create

  def index
    render json: users, adapter: :json
  end

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

  def users
    @users = User.all
  end

  def user_params
    params.require(:user).permit(:username, :password, :email, :first_name, :last_name)
  end
end
