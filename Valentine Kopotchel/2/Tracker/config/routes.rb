Rails.application.routes.draw do
  resources :ingestions
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :dishes
  devise_for :users
  root to:'ingestions#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
