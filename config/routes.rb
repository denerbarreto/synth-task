Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create, :update, :destroy]
      resources :sessions, only: [:new, :create, :destroy]
    end
  end
end
