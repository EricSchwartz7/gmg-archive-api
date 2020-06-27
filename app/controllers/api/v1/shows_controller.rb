module Api::V1
    class ShowsController < ApplicationController

        def filtered_shows
            year = params[:year_filter]
            venue = params[:venue_filter]

            year_params = year.empty? ? nil : Show.sql_year_string(year)
            venue_params = venue.empty? ? nil : {venue: venue}
            order_params = {date: params[:sort_order] == "most_recent" ? :desc : :asc}

            shows = Show.where(year_params).where(venue_params).order(order_params)
            shows_with_setlists = shows.map do |show| 
                {
                    venue: show.venue,
                    date: show.date,
                    first_set: show.get_single_set(1),
                    id: show.id
                }
            end
            render json: shows_with_setlists
        end
    
        def show
            show = Show.find(params[:id])
            show_with_setlist = {
                date: show.date,
                venue: show.venue,
                first_set: show.get_single_set(1)
            }
            render json: show_with_setlist
        end

        def edit
            show = Show.find(params[:id])
            render json: show
        end
        
        def create
            show = Show.create!(show_params)
            show.create_first_set(params[:first_set])
            render json: show
        end
        
        def update
            show = Show.find(params[:id])
            show.update_first_set(params[:first_set])
            render json: show
            # if show.update(show_params)
            # end
        end
        
        def destroy
            show = Show.find(params[:id])
            show.destroy
        end

        def years
            start_year = Show.order(:date).first.date.year
            end_year = Show.order(:date).last.date.year
            year_array = *(start_year..end_year)
            render json: year_array
        end

        def venues
            venues = Show.pluck(:venue).sort
            render json: venues
        end

        def get_videos
            videos = Show.find(params[:id]).videos
            render json: videos
        end
        
        private            
            def show_params
                params.require(:show).permit(:date, :venue, :first_set)
            end
    end
end