Rails.application.routes.draw do
  resources :events, only: [:index, :new, :create, :destroy]
  root 'events#index'
end
