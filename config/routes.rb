Rails.application.routes.draw do
  root to: 'electo#welcome'
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  resources :elections
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
