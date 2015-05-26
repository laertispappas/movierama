class RatingsController < ApplicationController
  before_action :authenticate_user!

  def update
    @rating = Rating.find(params[:id])
    @movie = @rating.movie
    if @rating.update_attributes(score: params[:score])
      respond_to do |format|
        format.js
      end
    end
  end
end