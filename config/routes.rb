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
      get "all_times_played", to: "songs#all_times_played"
      get "all_percentage_played", to: "songs#all_percentage_played"
      get "all_set_openers/:set_number", to: "songs#all_set_openers"
      get "all_set_closers/:set_number", to: "songs#all_set_closers"
      get "all_encore_appearances/", to: "songs#all_encore_appearances"
      get "show_appearances/:id", to: "songs#show_appearances"

    end
  end
end
