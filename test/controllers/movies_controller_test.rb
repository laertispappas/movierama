require 'test_helper'

class MoviesControllerTest < ActionController::TestCase

  def setup
    @user = User.first
    @user2 = User.last
    @movie = Movie.create(title: 'Game of thrones', description: 'Season1 winter is comming !!!', user: @user)
    @movie2 = Movie.create(title: 'Big bang theory', description: 'Big bang theory season 6 si coming', user: @user2)
    @request.env['HTTP_REFERER'] = 'http://test.host/users/sign_in'
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:movies)
  end

  test 'should get show' do
    get :show, id: @movie.id
    assert_response :success
    assert_not_nil assigns(:movie)
  end

  test 'should get new after sign in' do
    sign_in @user
    get :new
    assert_response :success
    assert_not_nil assigns(:movie)
  end

  test 'user should redirect to sign in page if trying to create a movie and not signed in' do
    get :new
    assert_response :redirect
    assert_redirected_to new_user_session_url

    assert_difference('Movie.count', 0) do
      post :create, { movie: { title: 'Game of thrones', description: 'Season1 winter is comming !!!', user: 1 } }, session
    end
    assert_redirected_to new_user_session_url
  end

  test 'user should create movie after sign in' do
    sign_in @user

    assert_difference('Movie.count') do
      post :create, { movie: { title: 'Game of thrones', description: 'Season1 winter is comming !!!', user: @user } }, session
    end
    assert_redirected_to movie_path(assigns(:movie))
  end

  test 'user should redirect to sign in page if trying to edit a movie and not signed in' do
    get :edit, { id: @movie.id }
    assert_response :redirect
    assert_redirected_to new_user_session_url

    put :update, { id: @movie.id, movie: { title: 'Game of thrones', description: 'Season1 winter is comming !!!', user: @user } }, session
    assert_redirected_to new_user_session_url
  end

  test 'user should update his a movie after sign in' do
    sign_in @user
    get :edit, id: @movie.id
    assert_response :success

    put :update, {id: @movie.id, movie: { title: 'Game of thrones edit', description: 'Season 1 winter is comming', user: @user } }, session
    assert_response :redirect
    assert_redirected_to movie_path(@movie)
  end

  test 'user cannot update other users movies' do
    assert_not_equal @user, @user2
    assert @movie.user, @user

    sign_in @user2
    get :edit, {id: @movie.id}, session
    assert_response :redirect
    assert_redirected_to root_url

    # ensure update action can not be called also
    put :edit, { id: @movie.id, movie: { title: 'Changed title of movie', description: 'Changed description', user: @user2 } }, session
    assert_response :redirect
    assert_redirected_to root_url
  end

  # like/hate/unvote action. NEED to DRY code!!!
  test 'cannot like/hate/unvote a movie if not signed in' do
    put :like, { id: @movie.id }
    assert_response :redirect
    assert_redirected_to new_user_session_url

    put :hate, { id: @movie.id }
    assert_response :redirect
    assert_redirected_to new_user_session_url

    put :unvote, { id: @movie.id }
    assert_response :redirect
    assert_redirected_to new_user_session_url
  end

  ############################# like action ##################################
  test 'can like a movie if signed in' do
    sign_in @user
    get :index

    @request.env['HTTP_REFERER'] = movie_path(@movie)

    assert_difference('ActsAsVotable::Vote.count') do
      put :like, { id: @movie2.id }, session
    end
    assert_response :redirect
    assert_redirected_to movie_path(@movie)
  end

  test 'cannot like the same movie more than once' do
    # sign in user and like a movie
    sign_in @user
    get :index

    @request.env['HTTP_REFERER'] = movies_path # simulation of redirect_to :back

    assert_difference('ActsAsVotable::Vote.count') do
      put :like, { id: @movie2.id }, session
    end

    assert_response :redirect
    assert_redirected_to movies_path

    # try making a put request for liking the same movie
    assert_no_difference('ActsAsVotable::Vote.count') do
      put :like, { id: @movie2.id }, session
    end
    assert_response :redirect
    assert_redirected_to movies_path
  end

  test 'cannot like his own movie' do
    sign_in @user

    assert_equal @movie.user, @user

    assert_no_difference('ActsAsVotable::Vote.count') do
      put :like, { id: @movie.id }, session
    end

    assert_response :redirect
    assert_redirected_to root_url
  end

  ############################# hate action ##################################
  test 'can hate a movie if signed in' do
    sign_in @user
    get :index

    @request.env['HTTP_REFERER'] = movie_path(@movie)

    assert_difference('ActsAsVotable::Vote.count') do
      put :hate, { id: @movie2.id }, session
    end
    assert_response :redirect
    assert_redirected_to movie_path(@movie)
  end

  test 'cannot hate the same movie more than once' do
    # sign in user and like a movie
    sign_in @user
    get :index

    @request.env['HTTP_REFERER'] = movies_path # simulation of redirect_to :back

    assert_difference('ActsAsVotable::Vote.count') do
      put :hate, { id: @movie2.id }, session
    end

    assert_response :redirect
    assert_redirected_to movies_path

    # try making a put request for hating the same movie
    assert_no_difference('ActsAsVotable::Vote.count') do
      put :hate, { id: @movie2.id }, session
    end
    assert_response :redirect
    assert_redirected_to movies_path
  end

  test 'cannot hate his own movie' do
    sign_in @user

    assert_equal @movie.user, @user

    assert_no_difference('ActsAsVotable::Vote.count') do
      put :hate, { id: @movie.id }, session
    end

    assert_response :redirect
    assert_redirected_to root_url
  end

  ############################# unvote action ##################################
  test 'can unvote a movie if signed in' do
    sign_in @user
    get :index

    @request.env['HTTP_REFERER'] = movie_path(@movie)
    put :like, { id: @movie2.id }, session
    put :unvote, { id: @movie2.id }, session
    assert_response :redirect
    assert_redirected_to movie_path(@movie)
    @movie.reload
    assert @movie.cached_votes_up.size, 0
  end

  test 'cannot unvote his own movie' do
    sign_in @user

    assert_equal @movie.user, @user

    assert_no_difference('ActsAsVotable::Vote.count') do
      put :unvote, { id: @movie.id }, session
    end

    assert_response :redirect
    assert_redirected_to root_url
  end
end