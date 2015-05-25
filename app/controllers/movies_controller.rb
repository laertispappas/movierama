class MoviesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @movies = Movie.all.paginate(page: params[:page], per_page: 10)
  end

  def new
    @movie = Movie.new
  end

  def show
    @movie = Movie.find(params[:id])
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


  private

  def movie_params
    params.require(:movie).permit(:title, :description)
  end
end
