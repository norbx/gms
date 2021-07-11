# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  def create
    user = User.new(sign_up_params)
    
    if user.save
      token = user.generate_jwt
      
      render json: { token: token.to_json }, status: :ok
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :username)
  end
end