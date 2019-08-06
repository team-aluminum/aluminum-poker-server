Rails.application.routes.draw do
  root 'application#index'
  resources :rooms, only: [:create], param: :code do
    resource :mobile_user, only: [:create, :destroy]
  end
  resources :users, only: [:create, :show], param: :code

  namespace :mobile_events do
    post :read_card
  end
end
