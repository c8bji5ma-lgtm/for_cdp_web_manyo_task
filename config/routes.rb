Rails.application.routes.draw do
  root "tasks#index"

  resources :tasks
  resources :labels, only: [:index, :new, :create, :edit, :update, :destroy]

  resources :users, only: [:new, :create, :show, :edit, :update]
  resource :session, only: [:new, :create, :destroy]

  namespace :admin do
    resources :users
  end
end