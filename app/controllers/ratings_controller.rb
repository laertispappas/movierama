class RatingsController < ApplicationController
  before_action :authenticate_user!

  # we use find or create by so a user cannot make a post request and rating the same movie more than once
  def create
    @rating = Rating.find_or_create_by(user_id: current_user.id, movie_id: params[:movie_id], score: params[:score])
    @movie = @rating.movie
    respond_to do |format|
      format.js { render file: 'ratings/update' }
    end
  end

  # should check if rating belongs to current user!!!
  def update
    @rating = Rating.find(params[:id])
    @movie = @rating.movie

    respond_to do |format|
      if @rating.update_attributes(score: params[:score]) and @rating.user == current_user
        format.js
      end
    end
  end
end