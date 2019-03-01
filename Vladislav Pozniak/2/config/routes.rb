# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :admin do
    resources :users
    resources :dishes

    root to: 'users#index'
  end
  root 'home#index'

  get 'users/:id/edit', to: redirect('profile')
  resources :ingestions, only: %i[index new create update edit destroy]
  resources :users, only: %i[new create update edit]
  resources :sessions, only: %i[new create destroy]
  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  get 'profile', to: 'users#edit', as: 'profile'
  get 'stats', to: 'ingestions#stats', as: 'stats'

  get 'admin/*path' => redirect('admin')
  get '*path' => redirect('/')
end
