Rails.application.routes.draw do

  get 'searches', to: 'searches#index', as: :search
  root 'movies#index'
  get '/user/:user_id/movies', to: 'profiles#movies', as: :user_movies

  resources :movies, only: [:index, :new, :create, :show] do
    resources :comments, only: [:create, :new]
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
