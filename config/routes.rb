Rails.application.routes.draw do
  root to: 'videos#index'

  get '/closed', to: 'public_pages#closed'

  namespace :admin do
    root 'pages#dashboard'
    resources :host_provider_accounts
  end

  resources :videos, only: [:index, :show, :edit, :update] do
    get :download, on: :member
    get 'page/:page', action: :index, on: :collection
  end

  resources :invites, only: [:index, :new, :create, :destroy]

  resources :passwords, controller: 'passwords', only: [:create, :new]
  resource :session, controller: 'sessions', only: [:create]

  resources :users, only: [:create, :show] do
    resource :password,
      controller: 'passwords',
      only: [:edit, :update]
  end

  get '/sign_in' => 'sessions#new', as: 'sign_in'
  delete '/sign_out' => 'sessions#destroy', as: 'sign_out'
  get '/sign_up' => 'users#new', as: 'sign_up'
end
