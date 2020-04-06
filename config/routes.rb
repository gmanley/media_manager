Rails.application.routes.draw do
  root to: 'videos#index'

  namespace :admin do
    root 'pages#dashboard'
    resources :host_provider_accounts
  end

  resources :videos, only: [:index, :show, :edit, :update] do
    get :download, on: :member
    get 'page/:page', action: :index, on: :collection
  end

  resources :invites, only: [:index, :new, :create, :destroy, :edit]

  resources :passwords, controller: 'clearance/passwords', only: [:create, :new]
  resource :session, controller: 'clearance/sessions', only: [:create]

  resources :users, only: [:create, :show] do
    resource :password,
      controller: 'clearance/passwords',
      only: [:edit, :update]
  end

  get '/sign_in' => 'clearance/sessions#new', as: 'sign_in'
  delete '/sign_out' => 'clearance/sessions#destroy', as: 'sign_out'
  get '/sign_up' => 'clearance/users#new', as: 'sign_up'
end
