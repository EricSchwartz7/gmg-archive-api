class Song < ApplicationRecord
    has_many :show_songs
    has_many :shows, through: :show_songs

    def times_played
        ShowSong.where(song_id: id).count
    end

    def set_opener_count(set_number)
        ShowSong.where({song_id: id, set: set_number, position: 0}).count
    end

    def set_appearance_shows(set_number)
        ShowSong.where({song_id: id, set: set_number}).map{ |show_song| show_song.show }
    end
    
    def set_closer_shows(set_number)
        first_set_appearance_shows.select do |show|
            show.get_single_set(set_number).last.id == id
        end
    end
end
