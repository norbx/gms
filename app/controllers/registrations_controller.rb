# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  skip_before_action :authenticate_user!

  def create
    user = User.new(sign_up_params)
    
    if user.save
      token = user.generate_jwt
      
      render json: { token: token }, status: :ok
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :first_name, :last_name, :password, :username)
  end
end