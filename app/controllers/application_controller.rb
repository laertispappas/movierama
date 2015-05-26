class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  require 'themoviedb'
  before_filter :set_config
  Tmdb::Api.key("d229d13edc95a19b2c5e4ee208d40e58")

  def set_config
    @configuration = Tmdb::Configuration.new
  end

  # don't trust user input
  def sort_column
    %w[likes hates date].include?(params[:sort]) ? params[:sort] : "likes"
  end
  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "desc"
  end

  helper_method :sort_column
  helper_method :sort_direction
end
