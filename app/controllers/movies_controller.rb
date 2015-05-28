class MoviesController < ApplicationController
  include Commentable  # concern

  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_movie, only: [:show, :like, :hate, :unvote, :edit, :update]
  before_action :require_same_user, only: [:edit, :update] # require the user who created the movie to only update the movie


  # User cannot like/hate their own movie. Although we do not show the action on view we must force to deny it in controller
  before_action :user_cannot_like_their_own_movies, only: [:like, :hate, :unvote] # i.e. using curl


  def index
    # sort_column, sort_direction are helper methods defined in Application controller
    @movies = Movie.includes(:user).sort_by(sort_column, sort_direction).paginate(page: params[:page], per_page: 10)
  end

  def new
    @movie = Movie.new
  end

  def edit
  end

  def update
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to @movie, notice: 'Movie was successfully updated.' }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @rating = Rating.find_or_initialize_by(user_id: current_user.id, movie_id: @movie.id) if current_user
    similar_movie_ids = current_user.recommendation_for @movie if current_user
    @recommended_movies = Movie.where(id: similar_movie_ids) if similar_movie_ids
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
    @movie.upvote_by current_user unless current_user.voted_up_for? @movie
    respond_to do |format|
      format.html { redirect_to(:back) }
    end
  end
  def hate
    @movie.downvote_by current_user unless current_user.voted_down_for? @movie
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
    params.require(:movie).permit(:title, :description, :picture)
  end

  def set_movie
    @movie = Movie.find(params[:id])
  end

  def user_cannot_like_their_own_movies
    if @movie.user == current_user
      flash[:alert] = "You can not like/hate your own movie"
      redirect_to movies_url
    end
  end

  def require_same_user
    if @movie.user != current_user
      flash[:alert] = 'You cannot edit this movie'
      redirect_to root_url
    end
  end

end
