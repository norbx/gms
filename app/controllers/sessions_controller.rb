# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  def create
    user = User.find_by_email(sign_in_params[:email])
  
    if user && user.valid_password?(sign_in_params[:password])
      token = user.generate_jwt
      
      render json: { token: token }, status: :ok
    else
      head :unprocessable_entity
    end
  end
end