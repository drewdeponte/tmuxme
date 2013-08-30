Tmuxme::Application.routes.draw do
  resources :users
  resources :sessions
  resources :password_resets
  resources :public_keys

  namespace :api do
    namespace :v1 do
      resources :users do
        resources :public_keys
      end
    end
  end

  root :to => 'landing_page#show'
end
