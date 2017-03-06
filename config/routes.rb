Rails.application.routes.draw do
  resources :reviews
  resources :users
  resources :release_groups
  #resources :artists
  #resources :releases
  root "search#index"
  get '/artist', to: 'search#artist'
  get '/search/:query' => 'search#search', :as => 'search'
end
