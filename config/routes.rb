Rails.application.routes.draw do
  root 'top#index'

  get 'passwords/edit'

  get 'accounts/show'

  get 'accounts/edit'

  resources :users
  
  resources :items
  
  resource :session, only: [:create, :destroy]
  resource :account, only: [:show, :edit, :update]
  resource :password, only: [:show, :edit, :update]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
