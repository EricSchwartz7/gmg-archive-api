class Show < ApplicationRecord
    has_many :videos
    has_many :photos
    has_many :audio_recs
    has_many :show_songs
    has_many :songs, through: :show_songs

    def self.sql_year_string(year)
        "date >= '#{year}-01-01' AND date <= '#{year}-12-31'"
    end

    # def self.all_songs
    #     first_set_songs = self.pluck(:first_set).join("\n").split(/[\n,]/)
    #     second_set_songs = self.pluck(:second_set).reject { |set| set.empty? }.join("\n").split(/[\n,]/)
    #     encore_songs = self.pluck(:encore).reject { |set| set.empty? }.join("\n").split(/[\n,]/)
    #     first_set_songs.concat(second_set_songs).concat(encore_songs)
    # end

    # def self.times_played(selected_song)
    #     self.all_songs.select { |song| song === selected_song }.count
    # end

    # def self.song_counts
    #     counts = Hash.new(0)
    #     self.all_songs.map { |song| counts[song] += 1 }
    #     counts.sort_by { |song, count| count }.reverse
    # end

    def get_single_set(set_number)
        return songs.merge(ShowSong.where(set: set_number).order(:position))
    end

    def merge_song_properties(show_song)
        song = Song.find(show_song.song_id)
        return {
            id: song.id,
            show_song_id: show_song.id,
            title: song.title,
            position: show_song.position,
            set: show_song.set
        }
    end

    def get_setlist
        show_songs.map { |show_song| merge_song_properties(show_song) }
    end

    def create_setlist(setlist)
        i = 0
        set = 1
        setlist.each do |song|

            if song[:set] != set
                i = 0
                set = song[:set]
            end

            ShowSong.create!({
                show_id: self.id,
                song_id: song[:id],
                set: set,
                position: i
            })

            i += 1
        end
    end

    def update_setlist(setlist)
        # Delete all ShowSongs related to the current show
        ShowSong.where(show_id: self.id).delete_all
        create_setlist(setlist)
    end
end