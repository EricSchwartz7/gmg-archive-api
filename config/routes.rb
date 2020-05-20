Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      # Shows
      resources :shows
      post "filtered_shows", to: "shows#filtered_shows"
      get "venues", to: "shows#venues"
      get "years", to: "shows#years"
      get "get_videos/:id", to: "shows#get_videos"
      
      # Videos
      resources :videos

      # Songs
      resources :songs
      post "filtered_songs", to: "songs#filtered_songs"
    end
  end
end
