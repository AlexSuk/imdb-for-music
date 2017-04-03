Rails.application.routes.draw do
  resources :users

  root "static_pages#index"
  get '/artist', to: 'static_pages#artist'
  get '/search/:query' => 'static_pages#search', :as => 'search'
  get '/signup', to: 'users#new'

  resources :posts do
    resources :comments
  end

  resources :comments do
    resources :comments
  end
end
