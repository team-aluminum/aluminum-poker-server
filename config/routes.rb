Rails.application.routes.draw do
  root 'application#index'
  resources :rooms, only: [:create], param: :code do
    post :setup, on: :collection
  end
  resources :users, only: [:create, :show, :update], param: :code

  namespace :mobile_events do
    post :mobile_user
    post :read_card
  end
end
