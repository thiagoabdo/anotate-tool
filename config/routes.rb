Rails.application.routes.draw do
  resources :observations
  resources :notations
  resources :attr_values
  resources :roles
  resources :entries
  resources :datasets

  get 'dataset/enter/:id', to: "datasets#enter", as: "dataset_enter"
  resources :datasets do
    resources :entries
    get "upload", to: "entries#gupload"
    post "upload", to: "entries#upload"
    get "share_link"
    delete "del_entries", to: "entries#destroy_all"
    resources :observations
    resources :members
    resources :notations
    get "choose_class", to: "notations#choose"
  end
  get 'pages/home'
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
