class MediaItemSong < ApplicationRecord
    belongs_to :media_items
    belongs_to :songs
end
