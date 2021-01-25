module Api::V1
    class VideosController < ApplicationController
        def create
            video = Video.create!(video_params)
            render json: video
        end

        def show
            videos = Show.find(params[:id]).videos
            render json: videos
        end

        def destroy
            video = Video.find(params[:id])
            video.destroy
            render json: {id: params[:id].to_i}
        end

        private
            def video_params
                params.permit(:title, :show_id, :url)
            end
    end
end
