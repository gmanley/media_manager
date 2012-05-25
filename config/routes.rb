MediaManager::Application.routes.draw do

  root to: 'media#index'

  resources :events
  resources :media, only: [:index, :show] do
    get :download, on: :member
    get 'page/:page', action: :index, on: :collection
  end
end