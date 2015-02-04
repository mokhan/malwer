Rails.application.routes.draw do
  resources :agents do
    resources :events, only: [:index, :new, :create, :destroy], controller: 'agents/events'
  end

  resources :dispositions
  root 'agents#index'
end
