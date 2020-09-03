Rails.application.routes.draw do
  resource :users, only: %i[create update destroy]
  resources :rooms, only: %i[index show]
  resources :reservations, only: %i[index show create destroy]

  post 'users/login', to: 'users#login'
end
