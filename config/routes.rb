MediaManager::Application.routes.draw do

  root to: 'media#index'
  resources :media, only: [:index, :show] do
    get 'page/:page', action: :index, on: :collection
  end
end
