Baby::Application.routes.draw do
  resources :login_sessions, only: [:index, :create], path: "login"
  get 'logout' => 'login_sessions#destroy'
  get 'login/:id/:code' => 'login_sessions#code', as: 'login_sessions_code'
  get 'home' => 'home#index'

  root to: 'landing#index'
end
