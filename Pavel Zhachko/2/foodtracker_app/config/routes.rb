Rails.application.routes.draw do
  devise_for :users
  resources :dishes
  resources :ingestions
  resources :users, only: %i[new create show destroy]
  #root 'dishes#index'
  root 'ingestions#index'
  get 'profile', to: 'users#show'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
