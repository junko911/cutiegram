Rails.application.routes.draw do
  resources :post_tags
  resources :tags
  resources :posts, except: [:index]
  
  resources :posts do
    resources :comments
    member do
       patch :like
    end
  end

  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
