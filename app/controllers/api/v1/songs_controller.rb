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
    end
end
