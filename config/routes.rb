Rails.application.routes.draw do

  root "static_pages#index"
  get '/search/:query' => 'static_pages#search', :as => 'search'

  get 'sessions/new'

  get '/artist',        to: 'catalog#artist'

  # posts resources
  get '/artist.:mbid/posts',                to: 'posts#index', as: 'artist_posts'
  get '/artist.:mbid/posts/new',            to: 'posts#new', as: 'artist_new_post'
  post '/artist.:mbid/posts',               to: 'posts#create', as: 'artist_create_post'
  delete '/artist.:mbid/posts/:id',         to: 'posts#destroy', as: 'artist_delete_post'

  get '/release-group', to: 'catalog#release_group'
  get 'recording',      to: 'catalog#recording'\

  get '/test',          to: 'static_pages#test'

  get  '/signup',   to: 'users#new'
  get  '/login',    to: 'sessions#new'
  post '/login',    to: 'sessions#create'
  delete '/logout',   to: 'sessions#destroy'

  resources :users
=begin
  resources :posts do
    resources :comments
  end
=end
  resources :comments do
    resources :comments
  end
end
