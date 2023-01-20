Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:show, :create, :update, :destroy]
      resources :sessions, only: [:new, :create, :destroy]
      resources :projects do
        resources :task_lists do
          resources :tasks, only: [:create]
        end
      end
    end
  end
end
