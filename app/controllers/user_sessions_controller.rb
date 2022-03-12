# frozen_string_literal: true

class UserSessionsController < ApplicationController
  skip_before_action :authenticate, only: :create

  def create
    if user&.authenticate(user_params[:password])
      render json: { token: token }, status: :ok
    else
      head :forbidden
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end

  def user
    User.find_by(email: user_params[:email])
  end

  def token
    JwtToken.generate_token(user)
  end
end
