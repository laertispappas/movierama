require 'test_helper'

class RatingTest < ActiveSupport::TestCase
  def setup
    @user = users(:user1)
    @movie = Movie.create(user: @user, title: 'Game of thrones', description: 'Game of thrones season1. Winter is coming!')
    @rating = Rating.create(movie: @movie, user: @user)
  end

  test 'rating is valid' do
    assert @rating.valid?
  end

  test 'default score should be 0' do
    @rating.save
    assert_equal 0, @rating.score
  end

  test 'score should be within [1,5]' do
    @rating.score = 6
    assert_not @rating.valid?
  end

  test 'user should not rate the same movie more than once' do
    @rating.score = 4
    @rating.save
    @rating = Rating.new(movie: @movie, user: @user, score: 3)
    assert_not @rating.valid?
  end

  test 'rating should have a user' do
    @rating.user = nil
    assert_not @rating.valid?
  end

  test 'rating should have a movie' do
    @rating.movie = nil
    assert_not @rating.valid?
  end

end
