Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"

    get "/help", to: "static_pages#help"

    get "/signup", to: "users#new"

    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"

    resources :users
    resources :users do
      member do
        resources :following, :followers, only: :index
      end
    end
    resources :account_activations, only: :edit
    resources :password_resets, only: %i(new create edit update)
    resources :microposts, only: %i(create destroy)
    resources :relationships, only: %i(create destroy)
  end
end
