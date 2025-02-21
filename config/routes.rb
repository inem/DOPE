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

    # Группируем все посты под /posts
    scope "posts" do
      # /posts/inem/abc-123 - конкретная версия поста
      get ":nickname/:uuid", to: "posts#show", as: :post
      # /posts/inem/abc-123/content - контент для локального приложения
      get ":nickname/:uuid/content", to: "posts#content", as: :post_content
    end

    # /inem/76etmuqm9 - последняя версия поста по timestamp_id
    get ":nickname/:timestamp_id", to: "posts#latest", as: :latest_post

    resources :posts, only: [ :destroy ]
  end
end
