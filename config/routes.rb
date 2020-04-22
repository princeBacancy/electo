# frozen_string_literal: true

Rails.application.routes.draw do
  default_url_options host: "https://enigmatic-mesa-31735.herokuapp.com/"
  root to: 'elections#index'
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    omniauth_callbacks: "users/omniauth_callbacks"
  }
  resources :payments, only: %i[index create] do
    member do
      get :election_payments
    end
  end
  
  resources :elections do
    member do
      get :start
      get :end
      post :vote
      get :result
      get :confirm
    end
    get :my_elections, on: :collection
    get :sample_file_download, on: :collection
  end

  resources :election_data, only: %i[destroy] do
    member do
      get :index
    end
  end

  resources :admin, only: %i[index] do
    member do
      get :show_user
      get :user_elections
      get :user_requests
      get :user_votes
      get :user_candidate
      get :user_winner
    end
  end

  resources :requests, only: %i[index] do
    member do
      get :send_requests
      get :received_requests
      get :election_requests
      get :approve
      delete :destroy
      post :import_voters
      get :new
      get :send_requests
      get :received_requests
    end
  end

  resources :voting_lists, only: %i[destroy] do
    member do
      get :index
    end
  end

  resources :winners, only: %i[destroy] do
    member do
      get :index
    end
  end

  resources :charges
  resources :notifications do
    collection do
      get :mark_as_read
    end
  end
  
  resources :messages, only: %i[new create]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
