class SearchesController < ApplicationController
  def index
    params[:direction] = :desc unless params[:direction].present?

    if params[:query].present?
      @movies = Movie.includes(:user).full_search(params[:query]).sort_search_results(sort_column, sort_direction).paginate(page: params[:page], per_page: 10)
    else
      @movies = Movie.includes(:user).sort_by(sort_column, sort_direction).paginate(page: params[:page], per_page: 10)
    end
  end
end
