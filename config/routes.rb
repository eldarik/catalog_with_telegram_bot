Rails.application.routes.draw do
  namespace :admin do
    resources :clients
    resources :departments
    resources :categories
    resources :products

    root to: "clients#index"
  end

end
