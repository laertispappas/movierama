Rails.application.routes.draw do
  get 'pages/:page', to: 'pages#home'

  get 'searches', to: 'searches#index', as: :search
  get 'search', to: 'searches#search_movie_db', as: :search_moviedb
  get 'search/:movie_id', to: 'searches#find_movie_db', as: :find_moviedb

  root 'movies#index'
  get '/profile/:user_id/movies', to: 'profiles#movies', as: :user_movies
  get '/profile/:user_id', to: 'profiles#show', as: :profile
  get '/profile/:user_id/votes', to: 'profiles#votes', as: :user_votes

  resources :ratings, only: [:update, :create]

  resources :movies, only: [:index, :new, :create, :show, :edit, :update] do
    resources :comments, only: [:create, :new]
    member do
      put "like", to: "movies#like"
      put "hate", to: "movies#hate"
      put "unvote", to: "movies#unvote"
    end
  end

  devise_for :users, controllers: {
                       sessions: 'users/sessions',
                       registrations: 'users/registrations',
                       :omniauth_callbacks => 'users/omniauth_callbacks'
  }
end
