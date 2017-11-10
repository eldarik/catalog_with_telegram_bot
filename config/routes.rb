Rails.application.routes.draw do
  namespace :admin do
    resources :clients
    resources :departments

    root to: "clients#index"
  end

end
