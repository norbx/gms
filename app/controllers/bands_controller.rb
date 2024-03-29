# frozen_string_literal: true

class BandsController < ApplicationController
  before_action :authenticate, only: %i[user_bands create update deactivation activation upload_images destroy_image]

  def index
    bands = search_params.empty? ? Band.all : Band.band_search(search_params)
    render json: bands, root: 'bands'
  end

  def user_bands
    render json: current_user.bands, apdater: :json, root: 'bands'
  end

  def show
    render json: Band.find(params[:id]), adapter: :json, root: 'band'
  end

  def create
    band = Band.new(band_params)

    if band.save
      current_user.bands << band
      render json: band, status: :created, root: 'band'
    else
      render json: band.errors.full_messages, root: 'band', status: :unprocessable_entity
    end
  end

  def update
    if band.update(band_params)
      render json: band, root: :band, status: :ok
    else
      render json: band.errors.full_messages, root: :bands, status: :bad_request
    end
  end

  def deactivation
    if band.update(active: false)
      render json: band, root: :band, status: :ok
    else
      render json: band.errors.full_messages, root: :bands, status: :bad_request
    end
  end

  def activation
    if band.update(active: true)
      render json: band, root: :band, status: :ok
    else
      render json: band.errors.full_messages, root: :bands, status: :bad_request
    end
  end

  def upload_images
    if band.images.attach(band_images['images'])
      render json: band, root: 'band', status: :created
    else
      render json: {
        errors: 'Image file should be lesser than 10mb ' \
                'and of content_type png, jpg or jpeg. Max 5 images per band are allowed.'
      }
    end
  end

  def destroy_image
    band.images.destroy(params[:image_id])

    render json: band, root: 'band', status: :ok
  end

  private

  def user
    @user = User.find(params[:user_id])
  end

  def band
    @band = current_user.bands.find(params[:id])
  end

  def band_params
    params.require(:band).permit(:name, :contact_name, :phone_number, :description, social_links: {},
                                                                                    tags_attributes: %i[id name])
  end

  def band_images
    params.permit(:id, { images: [] })
  end

  def search_params
    params.permit(:search)[:search]
  end
end
