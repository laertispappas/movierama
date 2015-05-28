require 'test_helper'

class MovieTest < ActiveSupport::TestCase
  def setup
    @user = User.create(fname: 'laertis', lname: 'pappas', email: 'laertis.pappas@gmail.com', password: 'pappaspappas', password_confirmation: 'pappaspappas')
    @movie = @user.movies.build(title: 'Game of thrones', description: 'One of the best series ever. Season 2 is coming soon!')
  end

  test 'movie should be valid' do
    assert @user.valid?
    assert @movie.valid?
  end

  test 'movie title and description must be present' do
    @movie.title = " "
    @movie.description = " "
    assert_not @movie.valid?
  end

  test 'title length should not be too short' do
    @movie.title = 'aaaa'
    assert_not @movie.valid?
  end

  test 'title length should not be too long' do
    @movie.title = 'a' * 101
    assert_not @movie.valid?
  end

  test 'description should not be too short' do
    @movie.description = 'a' * 19
    assert_not @movie.valid?
  end

  test 'description should not be too long' do
    @movie.description = 'a'*1001
    assert_not @movie.valid?
  end

  test 'user_id must be present' do
    @movie.user = nil
    assert_not @movie.valid?
  end

end
