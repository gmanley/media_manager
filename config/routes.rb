MediaManager::Application.routes.draw do

  root to: 'media#index'
  resources :media, only: [:index, :show]
end
