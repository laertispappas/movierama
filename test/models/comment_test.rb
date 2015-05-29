
class CommentTest < ActiveSupport::TestCase

  def setup
    @user = users(:user1)
    @movie = Movie.create(user: @user, title: 'Game of thrones', description: 'Game of thrones season1. Winter is coming!')
    @comment = Comment.create(user: @user, commentable_type: 'Movie', commentable_id: @movie.id, content: 'This is a comment')
  end

  test 'comemnt should be valid' do
    assert @comment.valid?
  end

  test 'comment should have content' do
    @comment.content = ' '
    assert_not @comment.valid?
  end

  test 'comment should have a user' do
    @comment.user = nil
    assert_not @comment.valid?
  end

  test 'comment should have a movie' do
    @comment.commentable = nil
    assert_not @comment.valid?
  end

  test 'should accept commentable type comment' do
    @reply_comment = Comment.new(content: 'reply comment', commentable_id: @comment.id, commentable_type: 'Comment', user: @user)
    assert @reply_comment.valid?
  end

  test 'should not accept other type of commentables' do
    @comment.commentable = @user
    assert_not @comment.valid?, "#{@comment.errors.full_messages}"
  end



end

