# frozen_string_literal: true

class UserSessionsController < ApplicationController
  def create
    if user&.authenticate(user_params[:password])
      render json: user, status: :ok, serializer: UserWithTokenSerializer, adapter: :attributes
    else
      head :forbidden
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end

  def user
    @user ||= User.find_by(email: user_params[:email])
  end
end
