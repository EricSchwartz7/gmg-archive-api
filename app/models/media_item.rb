class MediaItem < ApplicationRecord
    belongs_to :show
    has_many :songs, through: :media_item_songs

    def self.authenticate
        AuthorizeApiRequest.call(request.headers).result
    end
end