class SearchesController < ApplicationController


  # explanation for @current_user_movie_likes_ids is explained in movies#index or ApplicationController
  def index
    if params[:query].present?
      @movies = Movie.includes(:user).full_search(params[:query]).sort_search_results(sort_column, sort_direction).paginate(page: params[:page], per_page: 10)
      current_user_voted_movies_ids(@movies)  # inherit from application controller
    else
      @movies = []
      @current_user_movie_likes_ids = []
      @current_user_movie_hates_ids = []
    end

    respond_to do |format|
      format.html
      format.js
    end
  end


  # find movie details from moviedb API
  def find_movie_db
    @movie = Tmdb::Movie.detail(params[:movie_id])
    respond_to do |format|
#      format.js {  }
      format.json { render json: @movie }
    end
  end

  # search moviedb API for movies
  def search_movie_db
    if params[:query].present?
      @movies = Tmdb::Movie.find(params[:query])
      respond_to do |format|
        format.js {}
      end
    else
      respond_to do |format|
        format.json { head :no_content }
      end
    end
  end
end
