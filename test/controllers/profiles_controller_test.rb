require 'test_helper'

class ProfilesControllerTest < ActionController::TestCase
  def setup
    @user = User.first
    @movie = Movie.create(title: 'Game of thrones', description: 'Season1 winter is comming !!!', user: @user)
    @request.env['HTTP_REFERER'] = 'http://test.host/users/sign_in'
  end

  test "should get votes" do
    get :votes, user_id: @user.id

    assert_response :success
    assert_not_nil assigns(:movies)
  end

  test "should get show" do
    get :show, user_id: @user.id

    assert_response :success
    assert_not_nil assigns(:user)
    assert_not_nil assigns(:activities)

  end

  test "show get movies" do
    get :movies, user_id: @user.id

    assert_response :success
    assert_not_nil assigns(:movies)
  end

end
