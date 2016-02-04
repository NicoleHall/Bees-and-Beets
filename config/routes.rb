Rails.application.routes.draw do
  namespace :vendor, path: ':vendor', as: :vendor do
    resources :items, only: [:index, :show, :destroy]
  end
  resources :vendors, only: [:index, :show]

  resources :categories, only: [:index]

  namespace :category, path: ':category', as: :category do
    resources :items, only: [:index]
  end

  resources :cart_items, only: [:create, :destroy, :update]

  resources :users,
            only: [:new, :create, :show, :edit, :update],
            param: :slug do
    get "/cart", to: "cart_items#index"
    resources :orders, only: [:index, :create, :show]
    resources :items, only: [:new, :create, :edit, :update]
  end

  namespace :admin do
    get "/dashboard", to: "users#show"
    resources :items
    resources :orders, only: [:index, :update]
  end

  resources :artists, only: [:index, :show], param: :slug

  get "/cart", to: "cart_items#index"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  get "/logout", to: "sessions#destroy"
  get "/dashboard", to: "users#show"
  get "/categories_2", to: "categories#index_2"
  root "home#index"
end
