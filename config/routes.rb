Rails.application.routes.draw do
  root 'posts#index'
  resources :post_tags
  resources :tags
  resources :posts
  resources :searches
  
  resources :posts do
    resources :comments
    member do
       patch :like
    end
  end

  resources :users

  delete '/sessions/logout', to: 'sessions#logout', as: 'logout'
  get '/sessions/new', to: 'sessions#new', as: 'new_login'
  post '/sessions/create', to: 'sessions#create', as: 'login'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
