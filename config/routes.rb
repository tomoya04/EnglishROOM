Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  root to: "toppages#index"
  
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  
  get "signup", to: "users#new"
  resources :users, only: [:index, :show, :new, :edit,:update,:create, :destroy] do
    member do
      get :followings
      get :followers
       get :like
    end
  end
  
  resources :posts, only: [:show, :new, :edit,:update,:create, :destroy] do
    resources :comments, only: [:create]
     
  end
  resources :comments, only: [:destroy]
   
  resources :relationships, only: [:create,:destroy]
  resources :favorites, only: [:create, :destroy]
end
