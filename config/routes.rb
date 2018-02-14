require 'sidekiq/web'

Rails.application.routes.draw do
  get 'trades', to: 'trades#index'

  devise_for :users
  get 'lists/of_currencies'

  get 'lists/of_pairs'

  get 'lists/of_trios'

  get 'pages/home'
  root 'pages#home'

  resources :arbitrages
  # get 'arbitrages', to: 'arbitrages#index'

  mount Sidekiq::Web => '/sidekiq'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
