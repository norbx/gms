# frozen_string_literal: true

class BandsController < ApplicationController
  before_action :authenticate, only: %i[create update deactivation activation]
  before_action :verify_user, only: %i[create update deactivation activation]

  def index
    render json: Band.active, adapter: :json, root: 'bands'
  end

  def user_bands
    render json: user.bands.active, apdater: :json, root: 'bands'
  end

  def show
    render json: Band.find(params[:id]), adapter: :json, root: 'band'
  end

  def create
    band = Band.new(band_params)

    if band.save
      user.bands << band
      render json: band, status: :created, root: 'band'
    else
      render json: band.errors.full_messages, root: 'band', status: :unprocessable_entity
    end
  end

  def update
    if user_band.update(band_params)
      head :ok
    else
      render json: user_band.errors.full_messages, root: :bands, status: :bad_request
    end
  end

  def deactivation
    if user_band.update(active: false)
      head :ok
    else
      render json: user_band.errors.full_messages, root: :bands, status: :bad_request
    end
  end

  def activation
    if user_band.update(active: true)
      head :ok
    else
      render json: user_band.errors.full_messages, root: :bands, status: :bad_request
    end
  end

  private

  def user
    @user = User.find(params[:user_id])
  end

  def user_band
    @user_band = user.bands.find(params[:id])
  end

  def band_params
    params.require(:band).permit(:name, :contact_name, :phone_number, :description, :social_links)
  end
end
