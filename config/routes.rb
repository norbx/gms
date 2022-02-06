# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users, only: %i[index show create]

  scope :users do
    post :sessions, to: 'sessions#create', path: 'sign_in'
  end
end
