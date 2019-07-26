Rails.application.routes.draw do
  root 'application#index'
  resources :rooms, only: [:create]
end
