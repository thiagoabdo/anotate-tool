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
    resources :observations do
      resources :notations
    end
    resources :members
    resources :notations
    get "mynotations", to: "notations#my_notations"
    get "choose_class", to: "notations#choose"
    get "download"
    post "download", to: "datasets#generate"
  end
  devise_for :users
  root to: 'datasets#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
