Rails.application.routes.draw do
  resources :users, only: :create

  scope :users do
    post :sessions, to: 'sessions#create', path: 'sign_in'
  end
end
