Rails.application.routes.draw do
  resources :observations
  resources :notations
  resources :attr_values
  resources :roles
  resources :entries
  resources :datasets
  resources :datasets do
    resources :entries
    get "upload", to: "entries#gupload"
    post "upload", to: "entries#upload"
    delete "del_entries", to: "entries#destroy_all"
    resources :observations
  end
  get 'pages/home'
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
