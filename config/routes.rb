Rails.application.routes.draw do

  root "static_pages#index"
  get '/search/:query' => 'static_pages#search', :as => 'search'

  get 'sessions/new'

  get '/artist',        to: 'catalog#artist'
  get '/release-group', to: 'catalog#release_group'
  get 'recording',      to: 'catalog#recording'

  get  '/signup',   to: 'users#new'
  get  '/login',    to: 'sessions#new'
  post '/login',    to: 'sessions#create'
  delete '/logout',   to: 'sessions#destroy'

  resources :users
  resources :posts do
    resources :comments
  end

  resources :comments do
    resources :comments
  end
end
