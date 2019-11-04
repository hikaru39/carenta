Rails.application.routes.draw do
  root 'top#index'

  get 'passwords/edit'
  get 'accounts/show'
  get 'accounts/edit'
  get "login" => "users#login_form"
  post "login" => "users#login"

  get 'item_images/index'
  get 'item_images/new'
  get 'item_images/edit'

  resources :users do
    get "favorited", on: :member
    resources :points, on: :member, only: [:index, :new, :create]
  end
  
  resources :points

  resources :items, expect: [:destroy] do
    patch "like", "unlike", on: :member
    resources :images, controller: "item_images" do
      patch :move_higher, :move_lower, on: :member
    end
    resources :comments, only: [:create]
    collection do
      get 'category_index'
      get 'get_category_children', defaults: { format: 'json' }
      get 'get_category_grandchildren', defaults: { format: 'json' }
    end
  end
  
  resources :consumers, expect: [:destroy]
  resources :providers, only: [:index, :edit, :update]
  
  resource :session, only: [:create, :destroy]
  resource :account, only: [:show, :edit, :update]
  resource :password, only: [:show, :edit, :update]
  
  namespace :admin do
    root "top#index"
    resources :orders
  end
  
  # resources :category1 do
  #   resources :category2, on: :member do
  #     resources :category3, on: :member
  #   end
  # end
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
