MediaManager::Application.routes.draw do

  root to: 'videos#index'

  resources :events
  resources :videos, only: [:index, :show] do
    get :download, on: :member
    get 'page/:page', action: :index, on: :collection
  end
end