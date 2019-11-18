Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      # get "shows", to: "shows#index"
      resources :shows
      post "filtered_shows", to: "shows#filtered_shows"
      get "venues", to: "shows#venues"
      get "years", to: "shows#years"

      resources :videos
    end
  end
end
