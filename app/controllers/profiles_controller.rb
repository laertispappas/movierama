class ProfilesController < ApplicationController
  before_action :set_user

  def votes
    @movies_voted = @user.rated_movies.sort_by(sort_column, sort_direction).paginate(page: params[:page], per_page: 10)
  end

  def show
    @user = User.find(params[:user_id])
    @activities = PublicActivity::Activity.order("created_at desc").where(owner_id: @user.id, owner_type: "User").paginate(page: params[:page], per_page: 10)
  end

  def movies
    @movies = @user.movies.sort_by(sort_column, sort_direction).paginate(page: params[:page], per_page: 10)
  end


  private

  def set_user
    @user = User.find(params[:user_id])
  end
end