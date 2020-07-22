Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    devise_scope :user do
      get "/login", to: "devise/sessions#new", as: "login"
      post "/login", to: "devise/sessions#create"
      delete "/logout", to: "devise/sessions#destroy", as: "logout"
      get "/register", to: "devise/registrations#new", as: "register"
      put "/resetpassword", to: "devise/passwords#create", as: "reset_password"
    end
    namespace :profile do
      resources :users, only: %i(show edit update)
    end
    resources :products, only: %i(show index)
    post "carts/:id/add", to: "carts#add_item", as: "cart_add_item"
    delete "carts/:id/delete", to: "carts#remove_from_cart", as: "remove_from_cart"
    get "carts", to: "carts#index", as: "carts"
    get "/purchases", to: "purchases#new"
    resources :purchases, except: %i(home index destroy)
    patch "/purchases/:id", to: "purchases#update", as: "update_purchase"
    resources :categories, only: :index
    devise_for :users
    namespace :admin do
      root "products#index"
      resources :products, only: :import do
        collection {post :import}
      end
      resources :products, except: %i(show destroy)
      resources :purchases, only: %i(index edit update)
      resources :categories, except: %i(show destroy)
    end
  end
end
