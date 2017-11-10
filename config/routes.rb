Rails.application.routes.draw do
  namespace :admin do
    resources :clients

    root to: "clients#index"
  end

end
