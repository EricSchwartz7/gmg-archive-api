class ShowSong < ApplicationRecord
    belongs_to :show
    belongs_to :song
end
