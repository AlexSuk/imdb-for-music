Rails.application.routes.draw do

  root "static_pages#index"
  get '/search/:query' => 'static_pages#search', :as => 'search'

  resources :users
  resources :posts do
    member do
      get 'reply'
    end
  end

  get '/artist',        to: 'catalog#artist'
  get '/release-group', to: 'catalog#release_group'
  get 'recording',      to: 'catalog#recording'

  get '/signup', to: 'users#new'
  
end
