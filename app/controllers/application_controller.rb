class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # moviedb API find movies online
  require 'themoviedb'
  before_filter :set_config
  Tmdb::Api.key("d229d13edc95a19b2c5e4ee208d40e58")

  def set_config
    @configuration = Tmdb::Configuration.new
  end

  # we use instance variables current_user_movie_[likes hates]_ids to get the movie ids the current user has voted on @movies (likes, hates)
  # we do this so we do not have to hit the database again and again to check if current_user has voted on each movie (ex. index action).
  # In this way we hit the database only from this action and in view we check if @current_user_movie_[likes hates]_ids.include?(movie.id)
  # @current_user_movie_likes/hates_ids is a subset array of @movies and contains the movie ids the current_user has voted on
  def current_user_voted_movies_ids(movies)
    if current_user
      @current_user_movie_likes_ids = current_user.get_up_voted(Movie).where(id: movies.pluck(:id)).pluck(:id)
      @current_user_movie_hates_ids = current_user.get_down_voted(Movie).where(id: movies.pluck(:id)).pluck(:id)
    end
  end

  # don't trust user input. Helper methods Used to sort by likes/hates/date
  def sort_column
    %w[likes hates date].include?(params[:sort]) ? params[:sort] : "likes"
  end
  def sort_direction
    params[:direction] = :desc unless params[:direction].present?
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "desc"
  end

  helper_method :sort_column
  helper_method :sort_direction
end
