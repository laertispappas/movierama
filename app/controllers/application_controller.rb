class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception



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
