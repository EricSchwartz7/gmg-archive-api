class MediaItem < ApplicationRecord
    belongs_to :shows
    has_many :songs, through: :media_item_songs

    enum media_type: [:photo, :audio_rec, :video]
end