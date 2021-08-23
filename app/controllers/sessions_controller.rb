# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  skip_before_action :authenticate_user!

  def create
    user = User.find_by_email(sign_in_params[:email])
  
    if user && user.valid_password?(sign_in_params[:password])
      token = user.generate_jwt
      
      render json: { token: token }, status: :ok
    else
      head :unauthorized
    end
  end
end