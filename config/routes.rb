Rails.application.routes.draw do

  root "static_pages#index"
  get '/search/:query' => 'static_pages#search', :as => 'search'

  get 'sessions/new'

  get '/artist',        to: 'catalog#artist'
=begin
  # posts resources
  get '/artist.:mbid/posts',                to: 'posts#index'
  get '/artist.:mbid/posts/new',            to: 'posts#new'
  post '/artist.:mbid/posts',               to: 'posts#create'
  get '/artist.:mbid/posts/:post_id',       to: 'posts#show'
  delete '/artist.:mbid/posts/:post_id',    to: 'posts#destroy'
=end

  get '/release-group', to: 'catalog#release_group'
  get 'recording',      to: 'catalog#recording'\

  get '/test',          to: 'static_pages#test'

  get  '/signup',   to: 'users#new'
  get  '/login',    to: 'sessions#new'
  post '/login',    to: 'sessions#create'
  delete '/logout',   to: 'sessions#destroy'

  post 'users/add_favorite'
  post 'users/remove_favorite'

  match '/auth/:provider/callback', :to => 'sessions#create', via: [:get, :post]

  resources :users

  resources :posts do
    resources :comments
  end

  resources :comments do
    resources :comments
  end
end
