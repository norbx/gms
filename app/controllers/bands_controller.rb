# frozen_string_literal: true

class BandsController < ApplicationController
  before_action :authenticate, only: :update

  def index
    render json: Band.all, adapter: :json, root: 'bands'
  end

  def show
    render json: band, adapter: :json, root: 'band'
  end

  def create
    band = Band.new(band_params)

    if band.save
      render json: band, status: :created
    else
      render json: band.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    if band.update(band_params)
      render nothing: true, status: :ok
    else
      render json: band.errors.full_messages, root: :bands, status: :bad_request
    end
  end

  private

  def band
    @band = Band.find(params[:id])
  end

  def band_params
    params.require(:band).permit(:name, :contact_name, :phone_number, :description, :social_links)
  end
end
