Rails.application.routes.draw do
  resources :users
  resources :posts do
    member do
      get 'reply'
    end
  end

  root "static_pages#index"
  get '/artist', to: 'static_pages#artist'
  get '/search/:query' => 'static_pages#search', :as => 'search'
  get '/signup', to: 'users#new'
end
