Rails.application.routes.draw do
  resources :sessions, only: [:new, :create, :destroy]
  resources :agents do
    resources :events, only: [:index, :new, :create, :destroy], controller: 'agents/events'
    resources :files, only: [:index, :show], controller: 'agents/files'
  end

  resources :dispositions
  root 'agents#index'
end
