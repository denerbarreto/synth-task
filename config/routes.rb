Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:show, :create, :update, :destroy]
      resources :sessions, only: [:new, :create, :destroy]
      resources :task_lists, only: [:index, :show, :create, :update, :destroy]
      resources :projects, only: [:index, :create, :update]
    end
  end
end
