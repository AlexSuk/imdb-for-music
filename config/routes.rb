Rails.application.routes.draw do
  resources :release_groups
  #resources :artists
  root "search#index"
  get '/artist', to: 'search#artist'
  get '/search/:query' => 'search#search', :as => 'search'
end
