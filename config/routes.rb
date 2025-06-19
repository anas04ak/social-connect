Rails.application.routes.draw do
  resources :posts
  resources :users, only: [ :update, :edit]
  # get "/profile", to: "users#show", as: :user_profile 
  get 'profile/:id', to: 'users#show', as: 'user_profile'

   devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  resources :likes, only: [:create, :destroy]

  authenticated :user do
    root to: "posts#index", as: :authenticated_root

  end

  unauthenticated do
    # root to: "devise/sessions#new", as: :unauthenticated_root
    root to: redirect("/users/sign_in"), as: :unauthenticated_root
  end

  resources :posts do
    resources :comments, only: [:create, :destroy, :edit, :update, :index]
  end

  get '/profile', to: 'profiles#show', as: :profile

  # config/routes.rb
  get 'users/mentionable', to: 'users#mentionable'



  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
