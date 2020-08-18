Rails.application.routes.draw do
  get 'photos/upload'

  get 'photos/show'

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

      # MediaItems
      resources :media_items, only: [:create, :index, :show, :destroy]
      post "generate_signature/", to: "media_items#generate_signature"
      get "photos_from_show/:id", to: "media_items#photos_from_show"
      get "audio_recs_from_show/:id", to: "media_items#audio_recs_from_show"

      # AudioRecs
      # resources :audio_recs, only: [:create, :index, :show, :destroy]
      # get "audio_recs_from_show/:id", to: "audio_recs#audio_recs_from_show"


    end
  end
end
