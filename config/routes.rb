Rails.application.routes.draw do
  root to: 'electo#welcome'
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }


  resources :elections do
    member do
      get :start
      get :end 
      post :vote  
      get :result
    end
  end

  resources :election_data


  get "election/confirmation/:id" => "elections#confirm", as: "election_confirmation"
  get "request/approve/:id" => "requests#approve", as: "approve_request"
  delete "request/:id/delete" => "requests#destroy", as: "delete_request"
  get "request/:id" => "requests#index", as: "requests"
  get "request/:id/:type" => "requests#new", as: "request"
  post "request/import_voters/:id" => "requests#import_voters",as: "import_voters"

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
