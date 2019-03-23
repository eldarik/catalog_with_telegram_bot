Rails.application.routes.draw do
  mount Attachinary::Engine => "/attachinary"

  namespace :admin do
    resources :clients, only: [:show, :index]
    resources :departments
    resources :categories
    resources :products
    resources :orders, only: [:show, :index]

    root to: "clients#index"
  end

  root 'admin/clients#index'
end
