Rails.application.routes.draw do
  resource :users, only: [:create]
  resources :rooms, only: %i[index show]
  resources :reservations, only: %i[index show create destroy]

  post 'users/login', to: 'users#login'
end
