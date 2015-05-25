class MoviesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_movie, only: [:show, :like, :hate, :unlike, :unhate]

  def index
    @movies = Movie.sort_by(params[:sort]).paginate(page: params[:page], per_page: 10)
  end

  def new
    @movie = Movie.new
  end

  def show
  end

  def create
    @movie = Movie.new(movie_params)
    @movie.user = current_user

    respond_to do |format|
      if @movie.save
        flash[:success] = "Movie was successfully created."
        format.html { redirect_to @movie }
#        format.json { render json: @poll, status: :created, location: @movie }
      else
        flash[:alert] = 'There was a problem creating movie'
        render :new
#        format.json { render json: @poll.errors, status: :unprocessable_entity }
      end
    end
  end

  def like
    @movie.upvote_by current_user
    redirect_to movies_url
  end

  def hate
    @movie.downvote_by current_user
    redirect_to movies_url
  end

  def unlike
    @movie.unvote_by current_user
    redirect_to movies_url
  end

  def unhate
    @movie.unvote_by current_user
    redirect_to movies_url
  end

  private
  def movie_params
    params.require(:movie).permit(:title, :description)
  end

  def set_movie
    @movie = Movie.find(params[:id])
  end
end
