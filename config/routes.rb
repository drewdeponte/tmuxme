Tmuxme::Application.routes.draw do
  resources :users, :only => [:new, :create]
  resources :sessions, :only => [:new, :create, :destroy]
  resources :password_resets, :only => [:new, :create, :edit, :update]
  resources :public_keys, :only => [:index, :new, :create, :destroy]

  namespace :api do
    namespace :v1 do
      resources :users do
        resources :public_keys, :only => [:index]
      end
    end
  end

  root :to => 'landing_page#show'
end
