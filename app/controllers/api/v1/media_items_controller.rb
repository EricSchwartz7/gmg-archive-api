require 'json'
require 'open-uri'

module Api::V1
  class MediaItemsController < ApplicationController
    before_action :authenticate_request, except: [:index, :photos_from_show, :videos_from_show, :audio_recs_from_show]

    def create
      # params[:public_id]
      # params[:show_id]
      # params[:media_type]
      # params[:title]
      media_item = MediaItem.create!(media_item_params)
      render json: media_item
    end

    def generate_signature
      # get the api_secret (and keep it secret)
      api_secret = Cloudinary.config.api_secret
      # grab a current UNIX timestamp
      timestamp = Time.now.to_i
      # generate the signature using the current timestmap and any other desired Cloudinary params
      signature = Cloudinary::Utils.api_sign_request(
          {
            timestamp: params[:timestamp],
            upload_preset: params[:upload_preset],
            source: params[:source],
            tags: [params[:tags]]
          },
          api_secret
      );
      # craft a signature payload to send to the client (timestamp and signature required, api_key either sent here or stored on client)
      payload = {
        signature: signature,
        timestamp: timestamp
      };
      # send it back to the client
      render json: payload
    end
    
    def index
      media_items = Cloudinary::Api.resources
      render json: media_items
    end

    def photos_from_show
      photos = Cloudinary::Api.resources_by_tag(params[:id])
      render json: photos
    end

    def videos_from_show
      videos_and_audio = Cloudinary::Api.resources_by_tag(params[:id], {resource_type: "video"})
      # Audio files are considered to be resource type "video", but we can filter them out based on the "is_audio" property.
      videos = videos_and_audio["resources"].select{|media_item| media_item["is_audio"] != true}
      render json: videos
    end

    def audio_recs_from_show
      audio_recs = MediaItem.where(show_id: params[:id]).where(media_type: "audio");
      render json: audio_recs
    end

    def update
      media_item = MediaItem.find(params[:id])
      media_item.update(title: params[:title])
      render json: "success"
    end

    def destroy
      public_id = "gmg/" + params[:id]
      media_item = MediaItem.find_by(public_id: public_id)
      media_item.destroy unless media_item.nil?
      response = Cloudinary::Uploader.destroy(public_id)
      render json: {
        result: response["result"],
        public_id: public_id
      }
    end

    private            
    def media_item_params
        params.require(:media_item).permit(:public_id, :show_id, :media_type, :title)
    end

    def authenticate_request
      @current_user = AuthorizeApiRequest.call(request.headers).result
      render json: { error: 'Not Authorized' }, status: 401 unless @current_user
    end
  end
end
