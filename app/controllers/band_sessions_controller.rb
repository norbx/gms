# frozen_string_literal: true

class BandSessionsController < ApplicationController
  skip_before_action :authenticate, only: :create

  def create
    if band&.authenticate(band_params[:password])
      render json: { token: token }, status: :ok
    else
      head :forbidden
    end
  end

  private

  def band_params
    params.require(:band).permit(:email, :password)
  end

  def band
    Band.find_by(email: band_params[:email])
  end

  def token
    JwtToken.generate_token(band)
  end
end
