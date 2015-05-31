require 'rails_helper'

RSpec.describe MoviesController, type: :controller do

  before(:each) do
    @user = User.create(fname: 'laertis', lname: 'pappas', email: 'laertis.pappas@gmail.com', password: 'pappaspappas', password_confirmation: 'pappaspappas')
    @user.confirmed_at = Time.now
    @movie = Movie.create(title: 'test', description: 'test description goes here ... more desc', user_id: @user.id)
  end

  describe "GET #index" do
    it "render the index template" do
      @user.destroy!
      get :index
      expect(response).to render_template("index")
      expect(assigns(:movies)).to eq([])
    end

    it "shows @movies and returns http success" do
      get :index
      expect(assigns(:movies)).to eq([@movie])
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #new" do
    context  "when not signed in" do
      it "redirects if not logged in" do
        get :new
        expect(response).to have_http_status(302)
      end
    end

    context "when signed in" do
    end

  end



end
