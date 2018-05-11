Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'visual_artists/filter', :to => 'visual_artists#filter', :as => 'visual_artists_filter'
      get 'albums/search', :to => 'albums#search', :as => 'albums_search'
      resources :albums, only: [:index, :count, :update, :destroy, :create, :albums_search]
      resources :genres, only: [:index,:genre_filter]
      resources :visual_artists, only: [:index,:names, :visual_artists_filter]
      get 'genres/filter', :to => 'genres#filter', :as => 'genre_filter'
      get 'albums/count', :to => 'albums#count', :as => 'count'
      get 'visual_artists/names', :to => 'visual_artists#names', :as => 'names'

    end
  end
end
