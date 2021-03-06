module Api::V1
    class ShowsController < ApplicationController
        before_action :authenticate_request, only: [:create, :edit, :update, :destroy, :get_videos]

        def create
            show = Show.create!(show_params)
            show.create_setlist(params[:setlist])
            render json: show
        end

        def index
            year = params[:year_filter]
            venue = params[:venue_filter]
            sort_order = params[:sort_order]
            include_all = ActiveModel::Type::Boolean.new.cast(params[:include_all]) # Convert string to boolean

            shows_with_setlists = Show.filtered_shows(year, venue, sort_order, include_all)

            render json: shows_with_setlists
        end
    
        def show
            show = Show.find(params[:id])
            show_with_setlist = {
                date: show.date,
                venue: show.venue,
                setlist: show.get_setlist,
                id: show.id
            }
            render json: show_with_setlist
        end

        def edit
            show = Show.find(params[:id])
            render json: show
        end
        
        def update
            show = Show.find(params[:id])
            # show.update_date(params[:date])
            # show.update_venue(params[:venue])
            show.update(show_params)
            show.update_setlist(params[:setlist])
            render json: show
        end
        
        def destroy
            show = Show.find(params[:id])
            ShowSong.where(show_id: params[:id]).delete_all
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

        private            
            def show_params
                params.require(:show).permit(:date, :venue, :setlist, :songs)
            end

            def authenticate_request
                @current_user = AuthorizeApiRequest.call(request.headers).result
                render json: { error: 'Not Authorized' }, status: 401 unless @current_user
            end
    end
end