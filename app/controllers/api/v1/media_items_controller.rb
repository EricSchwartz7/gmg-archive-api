require 'json'
require 'open-uri'

module Api::V1
  class MediaItemsController < ApplicationController
    # def upload
    #   photo = Photo.new
    #   photo.filename = params[:file]
    #   photo.save!
    #   photo.filename.url
    # end

    def create
      image = Cloudinary::Uploader.upload(params[:image])
      # video = Cloudinary::Uploader.upload(params[:video], :resource_type => :video)
      media_item = MediaItem.create(image: image["url"])
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

    def media_items_from_show
      media_items = Cloudinary::Api.resources_by_tag(params[:id])
      render json: media_items
    end

    # def show
    #   url = JSON.parse open('https://res.cloudinary.com/gmg-archive-project/image/list/test.json').read
    # end

    def destroy
      public_id = "gmg/" + params[:id]
      response = Cloudinary::Uploader.destroy(public_id, options = {})
      render json: {
        result: response["result"],
        public_id: public_id
      }
    end
  end
end
