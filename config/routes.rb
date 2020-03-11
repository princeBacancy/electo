Rails.application.routes.draw do
  root to: 'elections#index'
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }


  resources :elections do
    member do
      get :start
      get :end 
      post :vote  
      get :result
      get :confirm
    end
    get :my_elections, on: :collection 
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
      get :election_requests
      get :approve
      delete :destroy
      post :import_voters
      get :new
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
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
