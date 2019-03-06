Rails.application.routes.draw do
  get 'ingestions/index'
  get 'static_pages/home'
  get 'sessions/new'
  root 'static_pages#home'
  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  
  resources :users
  resources :dishes
  resources :ingestions
end
