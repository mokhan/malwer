Rails.application.routes.draw do
  resources :agents do
    resources :events, only: [:index, :new, :create, :destroy], controller: 'agents/events'
    resources :files, only: [:index, :show], controller: 'agents/files'
  end

  namespace :api do
    resources :agents, only: [:create] do
      resources :events, only: [:create], controller: 'agents/events'
      resources :files, only: [:show], controller: 'agents/files'
    end
  end

  resources :dispositions
  root 'agents#index'
end
