Tmuxme::Application.routes.draw do
  resources :users, only: [:new, :create]
  resource :account, except: [:new, :create, :destroy, :patch]
  resources :sessions, only: [:new, :create, :destroy]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :public_keys, only: [:index, :new, :create, :destroy] do
    get :import, on: :collection
  end
  resources :auth_tokens, only: [:index, :destroy]

  match '/auth/:provider/callback', to: 'auth_tokens#callback', via: [:get, :post]

  namespace :api do
    namespace :v1 do
      resources :pairing_sessions, only: [:create]
      resources :users, constraints: { :id => /[^\/]+/ } do
        resources :public_keys, only: [:index]
      end
    end
  end

  root to: 'landing_page#show'
end
