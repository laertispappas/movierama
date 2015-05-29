class RatingsController < ApplicationController
  before_action :authenticate_user!
  before_action :accept_only_permitted_score

  # we use find or create by so a user cannot make a post request and rating the same movie more than once
  def create
    @rating = Rating.find_or_create_by(user_id: current_user.id, movie_id: params[:movie_id], score: params[:score])
    @movie = @rating.movie
    respond_to do |format|
      format.js { render file: 'ratings/update' }
      format.html { redirect_to :back }
    end
  end

  # should check if rating belongs to current user!!!
  def update
    @rating = Rating.find(params[:id])
    @movie = @rating.movie

    respond_to do |format|
      if @rating.update_attributes(score: params[:score]) and @rating.user == current_user
        format.js
        format.html { redirect_to :back }
      end
    end
  end

  private
  def accept_only_permitted_score
    # don't trust user input
    unless params[:score].in?([1,2,3,4,5])
      respond_to do |format|
        format.js { "alert('Not rated');" }
        format.html { redirect_to :back }
      end
      return
    end
  end

end