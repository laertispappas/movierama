class ProfilesController < ApplicationController
  before_action :set_user

  def votes
    @movies_voted = @user.rated_movies
  end

  def show
    @user = User.find(params[:user_id])
  end

  def movies
    params[:direction] = :desc unless params[:direction].present?
    @movies = @user.movies.sort_by(sort_column, sort_direction).paginate(page: params[:page], per_page: 10)
  end


  private

  def set_user
    @user = User.find(params[:user_id])
  end
end