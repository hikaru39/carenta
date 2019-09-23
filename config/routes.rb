Rails.application.routes.draw do
  root 'top#index'

  get 'passwords/edit'
  get 'accounts/show'
  get 'accounts/edit'

  get 'item_images/index'
  get 'item_images/new'
  get 'item_images/edit'

  resources :users do
    get "favorited", on: :member
    resources :points, on: :member, only: [:index, :new, :create]
  end

  resources :items, expect: [:destroy] do
    patch "like", "unlike", on: :member
    resources :images, controller: "item_images" do
      patch :move_higher, :move_lower, on: :member
    end
    resources :comments, only: [:create]
  end
  
  resource :session, only: [:create, :destroy]
  resource :account, only: [:show, :edit, :update]
  resource :password, only: [:show, :edit, :update]
  
  namespace :admin do
    root "top#index"
    resources :orders
  end
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
