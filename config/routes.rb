Rails.application.routes.draw do
  resource :users, only: [:create]
  resources :rooms, only: %i[index show]
  post 'users/login', to: 'users#login'

  namespace :users do
    resources :reservations, only: %i[index show create destroy]
  end
end
