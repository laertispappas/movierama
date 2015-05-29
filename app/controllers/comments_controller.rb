class CommentsController < ApplicationController
  before_action :authenticate_user!

  def new
    @parent_id = params.delete(:parent_id)    # if comment is nested
    @commentable = find_commentable           # find movie
    @comment = Comment.new( :parent_id => @parent_id,
                            :commentable_id => @commentable.id,
                            :commentable_type => @commentable.class.to_s)
    respond_to do |format|
      format.js { }
      format.html {}
    end
  end

  def create
    if params[:parent_id].present?

      @parent_id = params.delete(:parent_id)
      @commentable = find_commentable
      @comment = Comment.new( :parent_id => @parent_id,
                              :commentable_id => @commentable.id,
                              :commentable_type => @commentable.class.to_s)
    else
      @commentable = find_commentable
      @comment = @commentable.comments.build(comment_params)
      @comment.user = current_user
      if @comment.save
        flash[:notice] = "Successfully created comment."
        redirect_to movie_url(@commentable)
      else
        flash[:alert] = "Error adding comment."
        redirect_to movie_url(@commentable)
      end
    end
  end

  private
  def find_commentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end

  def comment_params
    params.require(:comment).permit(:content, :parent_id)
  end

end
