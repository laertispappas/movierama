Rails.application.routes.draw do
  root 'movies#index'

  resources :movies, only: [:index, :new, :create, :show] do
    member do
      put "like", to: "movies#like"
      put "hate", to: "movies#hate"
      put "unlike", to: "movies#unlike"
      put "unhate", to: "movies#unhate"
    end
  end

  devise_for :users, controllers: {
                       sessions: 'users/sessions',
                       registrations: 'users/registrations'
                   }
end
