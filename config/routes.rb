Rails.application.routes.draw do

  root "static_pages#index"
  get '/search/:query' => 'static_pages#search', :as => 'search'

  get 'sessions/new'
  get '/artist',        to: 'catalog#artist'
  get '/release-group', to: 'catalog#release_group'
  get 'recording',      to: 'catalog#recording'\

  get '/test',          to: 'static_pages#test'

  get  '/signup',   to: 'users#new'
  get  '/login',    to: 'sessions#new'
  post '/login',    to: 'sessions#create'
  delete '/logout',   to: 'sessions#destroy'

  post 'users/add_favorite'
  post 'users/remove_favorite'

  post '/reviews/write_review'
  get '/reviews/write_review'
  get '/reviews/show', to: 'reviews#show'
  post '/reviews/create'


  match '/auth/:provider/callback', :to => 'sessions#create', via: [:get, :post]

  resources :users

  # posts routes
  get '/artist.:mbid/posts',                to: 'posts#index', as: 'posts'
  get '/artist.:mbid/posts/new',            to: 'posts#new', as: 'new_post'
  post '/artist.:mbid/posts',               to: 'posts#create', as: 'create_post'
  delete '/artist.:mbid/posts/:id',         to: 'posts#destroy', as: 'delete_post'
  get '/artist.:mbid/posts/:id',              to: 'posts#show', as: 'post'
  get '/artist.:mbid/posts/:id/edit',       to: 'posts#edit', as: 'edit_post'
  patch '/artist.:mbid/posts/:id/edit',           to: 'posts#update', as: 'update_post'

  resources :posts do
    resources :comments
  end

  resources :comments do
    resources :comments
  end
end
