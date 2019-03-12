Rails.application.routes.draw do
  devise_for :users
  resources :dishes
  resources :users
  resources :ingestions
  #root 'dishes#index'
  root 'ingestions#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
