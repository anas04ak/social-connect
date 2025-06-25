Rails.application.routes.draw do
  get 'notifications/mark_as_read'
  resources :posts
  resources :users, only: %i[update edit]

  get 'profile/:id', to: 'users#show', as: 'user_profile'

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  resources :likes, only: %i[create destroy]

  authenticated :user do
    root to: 'posts#index', as: :authenticated_root
  end

  unauthenticated do
    root to: redirect('/users/sign_in'), as: :unauthenticated_root
  end

  resources :posts do
    resources :comments, only: %i[create destroy edit update index]
  end

  get '/profile', to: 'profiles#show', as: :profile

  get 'users/mentionable', to: 'users#mentionable'

  resources :notifications, only: [:index]
  post '/notifications/mark_as_read', to: 'notifications#mark_as_read', as: :mark_notifications_as_read

  post 'connect_instagram', to: 'instagram#connect'
  get  '/connect_instagram', to: 'instagram#new', as: 'new_instagram'
  delete '/disconnect_instagram', to: 'instagram#disconnect', as: :disconnect_instagram

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
