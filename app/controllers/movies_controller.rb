class MoviesController < ApplicationController
  include Commentable

  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_movie, only: [:show, :like, :hate, :unvote]

  def index
    params[:direction] = :desc unless params[:direction].present?
    @movies = Movie.includes(:user).sort_by(sort_column, sort_direction).paginate(page: params[:page], per_page: 10)
  end

  def new
    @movie = Movie.new
  end

  def show
    @rating = Rating.find_or_create_by(user_id: current_user.id, movie_id: @movie.id) if current_user
  end

  def create
    @movie = Movie.new(movie_params)
    @movie.user = current_user

    respond_to do |format|
      if @movie.save
        flash[:success] = "Movie was successfully created."
        format.html { redirect_to @movie }
      else
        flash[:alert] = 'There was a problem creating movie'
        format.html { render :new }
      end
    end
  end

  def like
    @movie.upvote_by current_user
    respond_to do |format|
      format.html { redirect_to(:back) }
    end
  end

  def hate
    @movie.downvote_by current_user
    respond_to do |format|
      format.html { redirect_to(:back) }
    end
  end

  def unvote
    @movie.unvote_by current_user

    respond_to do |format|
      format.html { redirect_to(:back) }
    end
  end

  private
  def movie_params
    params.require(:movie).permit(:title, :description)
  end

  def set_movie
    @movie = Movie.find(params[:id])
  end
end
