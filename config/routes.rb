Rails.application.routes.draw do
  root to: 'electo#welcome'
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  resources :elections

  get "election/confirmation/:id" => "elections#confirm", as: "election_confirmation"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
