Gratefulness::Application.routes.draw do

  root to: 'home#index'

  resources :users do
    resources :entries
  end

  match 'signup' => 'users#new', :as => :signup

  resources :user_sessions

  match 'logout' => 'user_sessions#destroy', :as => :logout
  match 'login' => 'user_sessions#new', :as => :login

  match 'home' => 'home#index'

end
