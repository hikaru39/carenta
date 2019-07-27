Rails.application.routes.draw do
  resources :members do
    get "search", on: :collection
  end
  
  resource :session, only: [:create, :destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
