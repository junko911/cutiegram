Rails.application.routes.draw do
  root 'posts#index'
  resources :post_tags
  resources :tags, only: [:show]
  resources :posts
  resources :searches
  
  resources :posts do
    resources :comments
  end

  resources :users
  resources :users do
    member do
      post 'follow'
      delete 'unfollow'
    end
  end

  delete '/sessions/logout', to: 'sessions#logout', as: 'logout'
  get '/sessions/new', to: 'sessions#new', as: 'new_login'
  post '/sessions/create', to: 'sessions#create', as: 'login'

  put '/post/:id/like', to: 'posts#like', as: 'like'
  delete '/post/:id/like', to: 'posts#unlike', as: 'unlike'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
