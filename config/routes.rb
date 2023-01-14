Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:show, :create, :update, :destroy]
      resources :sessions, only: [:new, :create, :destroy]
      resources :task_lists, only: [:index, :create, :update, :destroy]
    end
  end
end
