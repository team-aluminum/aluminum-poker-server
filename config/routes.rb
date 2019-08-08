Rails.application.routes.draw do
  root 'application#index'
  resources :rooms, only: [:create], param: :code
  resources :users, only: [:create, :show], param: :code

  namespace :mobile_events do
    post :mobile_user
    post :read_card
  end
end
