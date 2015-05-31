class MoviesController < ApplicationController
  include Commentable  # concern

  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_movie, only: [:show, :like, :hate, :unvote, :edit, :update]
  before_action :require_same_user, only: [:edit, :update] # a movie can be updated by its owner only
  before_action :user_cannot_like_their_own_movies, only: [:like, :hate, :unvote] # i.e. using curl

  # by default show top movies based on reddit ranking algorithm: see models/concerns/reddit_recommender.rb
  # current_user_voted_movies_ids(movies) id inherited from application controller and defines 2 instance variables: @current_user_movie_[likes hates]_ids
  # we use instance variables current_user_movie_[likes hates]_ids to get the movie ids the current user has voted on @movies (likes, hates)
  # we do this so we do not have to hit the database again and again to check if current_user has voted on each movie.
  # In this way we hit the database only from this action and in view we check if @current_user_movie_[likes hates]_ids.include?(movie.id)
  # @current_user_movie_likes/hates_ids is a subset array of @movies and contains the movie ids the current_user has voted on
  def index
    cookies[:joyride] ||= true
    # sort_column, sort_direction are helper methods defined in Application controller
    if params[:sort].present?
      @movies = Movie.includes(:user).sort_by(sort_column, sort_direction).paginate(page: params[:page], per_page: 10)
    else
      @movies = Movie.includes(:user).order(:reddit_score => :desc).paginate(page: params[:page], per_page: 10)
    end

    # iherited from Application controller
    current_user_voted_movies_ids(@movies)

    respond_to do |format|
      format.html
      format.js { render :js, file: 'movies/js/index' }
    end

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
      else
        format.html { render :edit }
      end
    end
  end

  def show
    if current_user
      @rating = Rating.find_or_initialize_by(user_id: current_user.id, movie_id: @movie.id)
      similar_movie_ids = current_user.recommendation_for @movie
      @recommended_movies = Movie.where(id: similar_movie_ids)
      # @recommended_movies = []
      # no need to call current_user_voted_movies_ids here just check if has voted on this movie
      @current_user_movie_likes_ids = current_user.voted_up_on?(@movie) ? [@movie.id] : []
      @current_user_movie_hates_ids = current_user.voted_down_on?(@movie) ? [@movie.id] : []
    end
  end

  def create
    @movie = Movie.new(movie_params)
    @movie.user = current_user

    respond_to do |format|
      if @movie.save
        @movie.create_activity :create, owner: current_user
        flash[:success] = "Movie was successfully created."
        format.html { redirect_to @movie }
      else
        flash[:alert] = 'There was a problem creating movie'
        format.html { render :new }
      end
    end
  end

  # For like/hate/unvote action we could like/hate/unvote directly without checking if user has already liked/hated/unvoted. We
  # can do it because we have binary votes. So we have 2 choices. 1) Check if user has voted so we make 1 db call and then if he has
  # voted redirect him to root_url. else if not, vote for movie so in sum we make 2 db calls for this approach.
  # 2) If we directly vote on movie we make 1 db call and the result is the same because of binary votes. We implement the 2nd approach.
  def like
    @movie.upvote_by current_user
    @movie.update_reddit_score
    respond_to do |format|
      format.html { redirect_to(:back) }
      format.js { render :js, file: 'movies/js/like' }
    end
  end

  def hate
    @movie.downvote_by current_user
    @movie.update_reddit_score
    respond_to do |format|
      format.html { redirect_to(:back) }
      format.js { render :js, file: 'movies/js/hate' }
    end
  end

  def unvote
    @movie.unvote_by current_user
    @movie.update_reddit_score
    respond_to do |format|
      format.html { redirect_to(:back) }
      format.js { render :js, file: 'movies/js/unvote' }
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
      redirect_to root_url
    end
  end

  def require_same_user
    if @movie.user != current_user
      flash[:alert] = 'You cannot edit this movie'
      redirect_to root_url
    end
  end
end
