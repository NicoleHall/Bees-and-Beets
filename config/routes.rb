Rails.application.routes.draw do
  resources :vendors, only: [:index, :new, :create, :edit, :update]

  resources :categories, only: [:index], param: :url do
    resources :items, only: [:index]
    # 'categories/food-stuff/items'
  end

  resources :cart_items, only: [:create, :destroy, :update]

  namespace :vendors, path: ':vendor', as: :vendor do
    resources :orders, only: [:index, :show, :update]
    resources :items, only: [:index, :show, :new, :create, :edit, :update]
  end

  resources :users,
            only: [:new, :create, :show, :edit, :update],
            param: :slug do
    get "/cart", to: "cart_items#index"
    resources :orders, only: [:index, :create, :show]
  end

  resources :addresses, only: [:new, :create, :index, :edit, :update, :destroy]
  #
  # namespace :admin do
  #   get "/dashboard", to: "users#show"
  #   resources :items
  #   resources :orders, only: [:index, :update]
  # end
  #
  # resources :artists, only: [:index, :show], param: :slug

  get "/cart", to: "cart_items#index"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  get "/logout", to: "sessions#destroy"
  get "/dashboard", to: "users#show"
  get "/vendor_dashboard", to: "vendor_dashboards#show"
  get "/manage_items", to: "vendors/items#index"
  get "/platform_dashboard", to: "platform_dashboards#show"
  put "/open_vendor", to: "vendors#open"
  put "/close_vendor", to: "vendors#close"
  put "/pending_vendor", to: "vendors#pending"
  root "home#index"
end
