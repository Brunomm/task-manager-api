Rails.application.routes.draw do
  devise_for :users, only: [:sessions], controllers: {sessions: 'api/v1/sessions'}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api, defaults: {format: :json}, constraints: {subdomain: 'api'}, path: '/' do
    namespace :v1 do
      resources :users, only: [:show, :create, :update, :destroy]
      resources :sessions, only: [:create, :destroy]
      resources :tasks, only: [:index, :show, :create, :update, :destroy]
    end

  	namespace :v2 do
      resources :users, only: [:show, :create, :update, :destroy]
      resources :sessions, only: [:create, :destroy]
  		resources :tasks, only: [:index, :show, :create, :update, :destroy]
  	end
  end
end
