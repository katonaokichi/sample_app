Rails.application.routes.draw do
  root "static_pages#home"
  get '/help', to: 'static_pages#help'
  get "/about", to: "static_pages#about"
  get "/contact", to: "static_pages#contact"

  get '/signup', to: "users#new"
  resources :users

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing
  # get  'static_pages/help' の場合 to:'static_pages#help'
  # 個別のurl_url  という urlヘルパーがつかえる
  # 個別のurl_path 
end