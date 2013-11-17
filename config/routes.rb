Gratefulness::Application.routes.draw do

  root to: 'home#index'

  resources :users do
    get 'entries/random', :to => 'entries#random'
    get 'entries/recent', :to => 'entries#recent'
    resources :entries
  end

  match 'signup' => 'users#new', :as => :signup

  resources :user_sessions

  match 'logout' => 'user_sessions#destroy', :as => :logout
  match 'login' => 'user_sessions#new', :as => :login

  match 'home' => 'home#index'

  match 'about' => 'about#index', :as => :about
  match 'what' => 'about#what', :as => :what

end
