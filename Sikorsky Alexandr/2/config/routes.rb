Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root 'home#index'
  resources :ingestions, only: %i[index new create update edit destroy]
  resources :dishes
  devise_for :users, controllers: { registrations: 'registrations' }

  namespace :charts do
    get 'average-calories'
    get 'ingestions-count'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
