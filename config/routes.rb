Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  # API routes
  namespace :api do
    resources :users, only: [ :create ]
    resources :posts, only: [ :create ]
  end

  scope module: :web do
    root "pages#home"

    get "posts/:user_uuid_tail/:post_uuid_tail", to: "posts#show", as: :post
    get ":nickname/:timestamp_id", to: "posts#latest", as: :latest_post
    resources :posts, only: [ :index ] do
      collection do
        get :latest
      end
    end

    get "/posts/:user_uuid_tail/:post_uuid_tail/content", to: "posts#content", as: :post_content
  end
end
