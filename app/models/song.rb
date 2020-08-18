class Song < ApplicationRecord
    has_many :show_songs
    has_many :shows, through: :show_songs
    has_many :media_items, through: :media_item_songs

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
