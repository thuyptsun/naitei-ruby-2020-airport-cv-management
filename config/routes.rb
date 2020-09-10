Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"

    get "/help", to: "static_pages#help"
    get "/contact", to: "static_pages#contact"

    resources :categories, only: :index
    resources :job_posts, except: %i(destroy update edit)
    resources :profiles, only: %i(show edit update)
    resources :job_applications, only: %i(index create update)
    resources :educations, only: %i(create update destroy)
    resources :experiences, only: %i(create update destroy)
    devise_for :users

    namespace :recruiters do
      resources :job_applications, only: %i(index create update)
      resources :job_posts
      resources :notifications, only: :index
    end
  end
  mount ActionCable.server => '/cable'
end
