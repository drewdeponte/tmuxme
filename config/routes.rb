Tmuxme::Application.routes.draw do
  resources :users
  resources :sessions
  resources :password_resets
  resources :public_keys

  root :to => 'landing_page#show'
end
