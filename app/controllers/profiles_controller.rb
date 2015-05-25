class ProfilesController < ApplicationController

  def movies
    params[:direction] = :desc unless params[:direction].present?

    @user = User.find(params[:user_id])
    @movies = @user.movies.sort_by(sort_column, sort_direction).paginate(page: params[:page], per_page: 10)
  end
end