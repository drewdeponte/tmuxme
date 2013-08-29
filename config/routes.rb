Tmuxme::Application.routes.draw do
  resources :users
  resources :sessions
  resources :password_resets

  root :to => 'sessions#new'
end
