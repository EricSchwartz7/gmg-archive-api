module Api::V1
    class SongsController < ApplicationController
        def filtered_songs
            # year = params[:year_filter]
            # venue = params[:venue_filter]

            # year_params = year.empty? ? nil : Show.sql_year_string(year)
            # venue_params = venue.empty? ? nil : {venue: venue}
            # order_params = {date: params[:sort_order] == "most_recent" ? :desc : :asc}

            # shows = Show.where(year_params).where(venue_params).order(order_params)

            songs = Song.all
            render json: songs
        end

        def index
            songs = Song.all
            render json: songs
        end

        def show
            song = Song.find(params[:id])
            render json: song
        end

        def all_times_played
            song_list = Song.map_all_songs(:times_played)
            render json: song_list
        end

        def all_percentage_played
            show_count = Show.active_show_count
            song_list = Song.map_all_songs(:percentage_played, show_count)
            render json: song_list
        end

        def all_set_openers
            set_number = params[:set_number].to_i
            song_list = Song.map_all_songs(:set_opener_shows, set_number)
            render json: song_list
        end

        def all_set_closers
            set_number = params[:set_number].to_i
            song_list = Song.map_all_songs(:set_closer_shows, set_number)
            render json: song_list
        end

        def all_encore_appearances
            song_list = Song.map_all_songs(:encore_appearances)
            render json: song_list
        end

        def show_appearances
            song = Song.find(params[:id])
            shows = song.shows.order(date: :desc)
            render json: shows
        end
    end
end
