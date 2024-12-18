Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }

  root "pages#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  post "favorites/:product_id/toggle", to: "favorites#toggle", as: "toggle_favorite"
  resources :favorites, only: [ :index, :destroy ]

  get "/cart", to: "carts#show", as: :cart
  post "cart_items/:product_id/add_item", to: "cart_items#add_item", as: "add_item_cart_items"
  post "cart_items/:product_id/add_item_from_favorites", to: "cart_items#add_item_from_favorites", as: "add_item_from_favorites_cart_items"

  delete "cart_items/:id/remove_item", to: "cart_items#remove_item", as: "remove_item_cart_items"
end
