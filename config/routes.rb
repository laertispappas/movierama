Rails.application.routes.draw do
  root 'movies#index'

  resources :movies, only: [:index, :new, :create, :show]

  devise_for :users, controllers: {
                       sessions: 'users/sessions',
                       registrations: 'users/registrations'
                   }



end
