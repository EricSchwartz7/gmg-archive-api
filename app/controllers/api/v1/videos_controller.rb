module Api::V1
    class VideosController < ApplicationController
        def create
            video = Video.create!(video_params)
            render json: video
        end

        private
            def video_params
                params.permit(:title, :show_id, :url)
            end
    end
end
