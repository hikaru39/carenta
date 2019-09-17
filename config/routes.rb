Rails.application.routes.draw do
  namespace :admin do
    get 'top/index'
  end
  get 'orders/index'
  get 'orders/show'
  get 'orders/new'
  get 'orders/edit'
  get 'points/index'
  get 'points/show'
  get 'points/new'
  get 'points/edit'
  get 'item_images/index'
  get 'item_images/new'
  get 'item_images/edit'
  root 'top#index'
  root 'items#index'

  get 'passwords/edit'

  get 'accounts/show'

  get 'accounts/edit'

  resources :users, except: [:index, :destroy] do
    get "favorited", on: :member
    resources :points, on: :member, only: [:index, :new, :create]
    resources :orders
  end
  
  resources :items, expect: [:destroy] do
    patch "like", "unlike", on: :member
    resources :images, controller: "item_images" do
      patch :move_higher, :move_lower, on: :member
    end
    resources :comments, only: [:create]
    resources :orders
  end
  
  resources :orders
  resource :session, only: [:create, :destroy]
  resource :account, only: [:show, :edit, :update]
  resource :password, only: [:show, :edit, :update]
  
  namespace :admin do
    root "top#index"
    resources :users do
      get "search", on: :collection
    end
    resources :items
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
