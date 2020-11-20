Rails.application.routes.draw do
  root "static_pages#home"
  get 'static_pages/home'
  get 'static_pages/help'
  get "static_pages/about"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  # コントローラー名_アクション名_url  という urlヘルパーがつかえる
  # root_url (特殊)
end
