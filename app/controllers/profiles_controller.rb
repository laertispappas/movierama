class ProfilesController < ApplicationController
  before_action :set_user

  def votes
    if params[:sort].present?
      @movies = @user.rated_movies.sort_by(sort_column, sort_direction).paginate(page: params[:page], per_page: 10)
    else
      @movies = @user.rated_movies.includes(:user).order(:reddit_score => :desc).paginate(page: params[:page], per_page: 10)
    end
    current_user_voted_movies_ids(@movies)
  end

  # user activity
  def show
    @activities = PublicActivity::Activity.order("created_at desc").where(owner_id: @user.id, owner_type: "User").paginate(page: params[:page], per_page: 10)
    @most_popular_movies ||= @user.movies.order(:cached_votes_up => :desc).limit(5)
    respond_to do |format|
      format.html {  }
      format.js { render :js, file: 'profiles/show' }
    end
  end

  def movies
    if params[:sort].present?
      @movies = @user.movies.sort_by(sort_column, sort_direction).paginate(page: params[:page], per_page: 10)
    else
      @movies = @user.movies.order(:reddit_score => :desc).paginate(page: params[:page], per_page: 10)
    end
    current_user_voted_movies_ids(@movies)
  end


  private
  def set_user
    @user = User.find(params[:user_id])
  end
end