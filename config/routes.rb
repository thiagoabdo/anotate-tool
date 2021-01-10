Rails.application.routes.draw do
  #resources :ml_orders
  #resources :ml_notations
  #resources :ml_features
  resources :observations
  resources :notations
  resources :attr_values
  resources :roles
  resources :entries
  resources :datasets

  resources :observations do
    get "aa", to: "observations#active_learn"
    get "ai", to: "observations#interactive_learn"
    get "kfold", to: "observations#kfold"
    get "getall", to: "observations#getall"
    get "getallentries", to: "observations#getallentries"
    get "getallnot", to: "observations#getallnot"
    get "getallattr", to: "observations#getallattr"
    put "reportstats", to: "observations#reportstats"
    post "new_kfold"
    delete "delete_kfold"
    delete "delete_aa", to: "observations#delete_active_learn"
    delete "delete_ai", to: "observations#delete_interactive_learn"
    put "put_aa", to: "observations#put_active_learn"
    put "put_ai", to: "observations#put_interactive_learn"
    put "put_kfold"

    put "ml_notation", to: "observations#put_ml_notation"
    put "ml_order", to: "observations#put_ml_order"
    delete "ml_order", to: "observations#del_ml_order"
  end
  get 'observation/getalllearn', to: "observations#getalllearn"

  put "ml_feature/:id", to: "ml_features#pupdate"

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
    get "get_features", to: "ml_features#getall"
    get "mynotations", to: "notations#my_notations"
    get "choose_class", to: "notations#choose"
    get "download"
    post "download", to: "datasets#generate"
    get "needfeatures", to: "ml_features#needfeatures"
    get "inference"
  end
  devise_for :users
  root to: 'datasets#index'
  get 'observation/getalllearn', to: "observations#getalllearn"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
