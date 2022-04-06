# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users, only: %i[index show create]
  resources :bands, only: %i[index show]
  resources :tags, only: %i[index show]

  scope :profile do
    post :sessions, to: 'user_sessions#create', path: 'sign_in'
    put :avatar, to: 'users#upload_avatar'
    resources :bands, only: %i[create update] do
      put :deactivation, on: :member
      put :activation, on: :member
      post :images, to: 'bands#upload_images', on: :member
      delete 'images(/:image_id)', to: 'bands#destroy_image', on: :member
    end
    get '/bands', to: 'bands#user_bands'
  end
end
