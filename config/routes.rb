Rails.application.routes.draw do
  root "search#index"
  get '/artist', to: 'search#artist'
  get '/search/:query' => 'search#search', :as => 'search'
end
