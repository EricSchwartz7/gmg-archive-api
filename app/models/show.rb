class Show < ApplicationRecord
    has_many :videos
    has_many :audio_recs
    has_many :show_songs
    has_many :media_items
    has_many :songs, through: :show_songs

    def self.filtered_shows(year, venue, sort_order, include_all)
        year_params = year.empty? ? nil : Show.sql_year_string(year)
        venue_params = venue.empty? ? nil : {venue: venue}
        order_params = {date: sort_order == "most_recent" ? :desc : :asc}

        if (include_all)
            shows = Show.where(year_params).where(venue_params).order(order_params)
        else
            # sql = "(SELECT shows.* FROM shows
            #     JOIN videos ON shows.id = videos.show_id)
            #     UNION
            #     (SELECT shows.* FROM shows
            #     JOIN media_items ON shows.id = media_items.show_id)"
            # shows = ActiveRecord::Base.connection.execute(sql).values
            shows_with_media_items = Show.joins(:media_items).where(year_params).where(venue_params).group(:id)
            shows_with_youtubes = Show.joins(:videos).where(year_params).where(venue_params).group(:id)
            shows = (shows_with_media_items | shows_with_youtubes).sort_by(&:date)
            shows.reverse! if order_params[:date] == :desc
        end
        shows.map do |show| 
            {
                venue: show.venue,
                date: show.date,
                setlist: show.get_setlist,
                id: show.id
            }
        end
    end

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
        # Delete all ShowSongs related to the current show, then recreate setlist
        ShowSong.where(show_id: self.id).delete_all
        create_setlist(setlist)
    end

    def self.active_show_count
        sql = "SELECT show_id, Count(1) FROM songs
                INNER JOIN show_songs ON songs.id = show_songs.song_id 
                GROUP BY show_id"
        ActiveRecord::Base.connection.execute(sql).values.count.to_f
    end
end