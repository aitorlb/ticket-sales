# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'authenticate', to: 'authentication#authenticate'
      resources :events, only: %i[index show] do
        resources :tickets, only: %i[index]
        resources :purchases do
          collection do
            put :update
            post :create
          end
        end
      end
    end
  end
end
