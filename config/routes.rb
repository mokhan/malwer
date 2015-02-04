Rails.application.routes.draw do
  resources :dispositions
  resources :events, only: [:index, :new, :create, :destroy]
  root 'events#index'
end
