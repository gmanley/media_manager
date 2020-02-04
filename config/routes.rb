Rails.application.routes.draw do
  root to: 'videos#index'

  get '/admin', to: 'admin#dashboard'

  resources :host_provider_accounts
  resources :videos, only: [:index, :show, :edit, :update] do
    get :download, on: :member
    get 'page/:page', action: :index, on: :collection
  end
end
