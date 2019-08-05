Rails.application.routes.draw do
  root 'application#index'
  resources :rooms, only: [:create, :show], param: :code do
    resource :mobile_user, only: [:create, :destroy]
  end
  resources :users, only: [:create]
end
