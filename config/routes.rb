Rails.application.routes.draw do
  resources :reviews
  resources :users
  resources :posts do
    member do
      get 'reply'
    end
  end

  #resources :release_groups
  #resources :artists
  root "search#index"
  get '/artist', to: 'search#artist'
  get '/search/:query' => 'search#search', :as => 'search'
  get '/signup', to: 'users#new'
end
