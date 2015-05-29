require 'test_helper'

# ratings with stars
class RatingsControllerTest < ActionController::TestCase
  def setup
    @user = User.first
    @movie = Movie.create(title: 'Game of thrones', description: 'Season1 winter is comming !!!', user: @user)
  end

  test "only singned in users should rate (star rating)" do
    assert_no_difference('Rating.count', 0) do
      post :create, movie_id: @movie.id, user_id: @user.id
    end
    assert_redirected_to new_user_session_url
  end

  test 'signed in user should rate a movie' do
    sign_in @user
    @request.env['HTTP_REFERER'] = movie_path(@movie)

    assert_difference('Rating.count', 0) do
      post :create, user_id: @user.id, movie_id: @movie.id
    end
    assert_redirected_to movie_path(@movie)
  end

  test 'should not be created without parameters' do
    sign_in @user
    @request.env['HTTP_REFERER'] = movie_path(@movie)

    assert_no_difference('Rating.count', 0) do
      post :create
    end
    assert_redirected_to movie_path(@movie)
  end

  test 'should not update if not signed in' do
    assert_no_difference('Rating.count', 0) do
      put :update, id: @movie.id
    end
    assert_redirected_to new_user_session_url
  end

end