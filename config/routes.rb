Rails.application.routes.draw do

  root 'movies#index'

  get '/user/:user_id/movies', to: 'profiles#movies', as: :user_movies

  resources :movies, only: [:index, :new, :create, :show] do
    member do
      put "like", to: "movies#like"
      put "hate", to: "movies#hate"
      put "unvote", to: "movies#unvote"
    end
  end

  devise_for :users, controllers: {
                       sessions: 'users/sessions',
                       registrations: 'users/registrations'
                   } do
  end
end
