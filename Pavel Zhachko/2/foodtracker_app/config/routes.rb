Rails.application.routes.draw do
  devise_for :users
  resources :dishes
  resources :ingestions
  resources :users, only: %i[new create show destroy]
  root 'ingestions#index'
  as :user do
    get  'sign_in', to: 'devise/sessions#new'
    post 'sign_in', to: 'devise/sessions#create'
    get 'logout', to: 'devise/sessions#destroy'
    get 'profile', to: 'users#show'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
