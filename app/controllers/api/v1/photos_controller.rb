require 'json'
require 'open-uri'

module Api::V1
  class PhotosController < ApplicationController
    def upload
      photo = Photo.new
      photo.filename = params[:file]
      photo.save!
      photo.filename.url
    end

    def create
      image = Cloudinary::Uploader.upload(params[:image])
      # video = Cloudinary::Uploader.upload(params[:video], :resource_type => :video)
      photo = Photo.create(image: image["url"])
      render json: photo
    end
    
    def index
      photos = Cloudinary::Api.resources
      render json: photos
    end

    def photos_from_show
      photos = Cloudinary::Api.resources_by_tag(params[:id])
      render json: photos
    end

    def show
      url = JSON.parse open('https://res.cloudinary.com/gmg-archive-project/image/list/test.json').read
    end
  end
end
