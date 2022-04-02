# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users, only: %i[index show create] do
    resources :bands, only: %i[create update] do
      put 'deactivation', on: :member
      put 'activation', on: :member
    end
    get '/bands', to: 'bands#user_bands'
  end

  resources :bands, only: %i[index show]
  resources :tags, only: %i[index show]

  scope :users do
    post :sessions, to: 'user_sessions#create', path: 'sign_in'
  end
end
