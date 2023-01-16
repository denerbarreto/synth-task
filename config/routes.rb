Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:show, :create, :update, :destroy]
      resources :sessions, only: [:new, :create, :destroy]
      resources :projects do
        resources :task_lists
        resources :task_lists, path: 'relationships/task_lists'
      end
    end
  end
end
