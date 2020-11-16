class Song < ApplicationRecord
    has_many :show_songs
    has_many :shows, through: :show_songs
    has_many :media_items, through: :media_item_songs

    ### Constants ###



    ### Instance methods ###

    def times_played
        ShowSong.where(song_id: id).count
    end

    def percentage_played(active_show_count)
        percentage = times_played / active_show_count
        (percentage * 100).round(1)
    end

    def set_opener_shows(set_number)
        ShowSong.where({song_id: id, set: set_number, position: 0}).count
    end

    def set_appearance_shows(set_number)
        ShowSong.where({song_id: id, set: set_number}).map{ |show_song| show_song.show }
    end
    
    def set_closer_shows(set_number)
        set_appearance_shows(set_number).select do |show|
            show.get_single_set(set_number).last.id == id
        end.count
    end

    def encore_appearances
        ShowSong.where({song_id: id, set: 3}).count
    end


    ### Class methods ###

    def self.calculate_stat(stat)
        stat_methods = {
            times_played: times_played,
            percentage_played: percentage_played,
            first_set_openers: set_openers(1),
            second_set_openers: set_openers(2),
            first_set_closers: set_closers(1),
            second_set_closers: set_closers(2),
            encore_appearances: encore_appearances
        }
        stat_methods[stat.to_sym]
    end

    def self.format_stat_array(stat_hash)
        stat_hash.map do |key, value|
            {
                id: key[0],
                title: key[1],
                value: value
            }
        end
    end

    def self.set_openers(set_number)
        songs_with_counts = Song.joins(:show_songs)
            .where(show_songs: { set: set_number, position: 0 })
            .group(:song_id, :title)
            .order("count_all desc")
            .count

        format_stat_array(songs_with_counts)
    end

    def self.set_opening_songs(set_number)
        ShowSong.where({set: set_number, position: 0})
    end

    # def self.all_set_openers(set_number)
    #     show_songs = set_opening_songs(set_number)
    #     song_list = all.map do |song|
    #         {   
    #             id: song.id,
    #             title: song.title,
    #             value: show_songs.select{ |show_song| show_song.song_id == song.id }.count
    #         }
    #     end
    #     song_list
    #         .select{ |song| song[:value] > 0 }
    #         .sort_by{ |song| -song[:value] }
    # end

    def self.map_all_songs(calculation, set_number_or_show_count = 0)
        song_list = all.map do |song|
            value = set_number_or_show_count > 0 ? song.send(calculation, set_number_or_show_count) : song.send(calculation)
            {
                id: song.id,
                title: song.title,
                value: value
            }
        end
        song_list
            .select{ |song| song[:value] > 0 }
            .sort_by{ |song| -song[:value] }
    end

    # def self.all_songs_times_played
    #     song_list = all.map do |song|
    #         {
    #             id: song.id,
    #             title: song.title,
    #             value: song.times_played
    #         }
    #     end
    #     song_list.sort_by{ |song| -song[:value] }
    # end

    # def self.all_songs_percentage_played
    #     song_list = all.map do |song|
    #         {
    #             id: song.id,
    #             title: song.title,
    #             value: song.percentage_played
    #         }
    #     end
    #     song_list.sort_by{ |song| -song[:value] }
    # end

    # def self.all_set_openers(set_number)
    #     song_list = all.map do |song|
    #         {
    #             id: song.id,
    #             title: song.title,
    #             value: song.set_opener_shows(set_number).count
    #         }
    #     end
    #     song_list
    #         .select{ |song| song[:value] > 0 }
    #         .sort_by{ |song| -song[:value] }
    # end

    # def self.all_set_closers(set_number)
    #     song_list = all.map do |song|
    #         {
    #             id: song.id,
    #             title: song.title,
    #             value: song.set_closer_shows(set_number).count
    #         }
    #     end
    #     song_list
    #         .select{ |song| song[:value] > 0 }
    #         .sort_by{ |song| -song[:value] }
    # end

    # def self.all_encore_appearances
    #     song_list = all.map do |song|
    #         {
    #             id: song.id,
    #             title: song.title,
    #             value: song.encore_appearances.count
    #         }
    #     end
    #     song_list
    #         .select{ |song| song[:value] > 0 }
    #         .sort_by{ |song| -song[:value] }
    # end
end
