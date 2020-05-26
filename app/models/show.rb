class Show < ApplicationRecord
    has_many :videos
    has_many :photos
    has_many :audio_recs
    has_many :show_songs
    has_many :songs, through: :show_songs

    def self.sql_year_string(year)
        "date >= '#{year}-01-01' AND date <= '#{year}-12-31'"
    end

    def self.all_songs
        first_set_songs = self.pluck(:first_set).join("\n").split(/[\n,]/)
        second_set_songs = self.pluck(:second_set).reject { |set| set.empty? }.join("\n").split(/[\n,]/)
        encore_songs = self.pluck(:encore).reject { |set| set.empty? }.join("\n").split(/[\n,]/)
        first_set_songs.concat(second_set_songs).concat(encore_songs)
    end

    def self.times_played(selected_song)
        self.all_songs.select { |song| song === selected_song }.count
    end

    def self.song_counts
        counts = Hash.new(0)
        self.all_songs.map { |song| counts[song] += 1 }
        counts.sort_by { |song, count| count }.reverse
    end

    def get_single_set(set_number)
        return songs.merge(ShowSong.where(set: set_number))
    end

    def create_first_set(first_set_ids)
        first_set_ids.each_with_index{ |id, index| 
            ShowSong.create!({
                show_id: self.id,
                song_id: id,
                set: 1,
                position: index
            })
        }
    end
end