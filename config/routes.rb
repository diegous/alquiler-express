Rails.application.routes.draw do
  resource :session
  resource :registration, only: %i[ new create ]
  resources :passwords, param: :token
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  root "living_properties#index"

  resources :commercial_properties, only: %i[index show]

  resources :living_properties, only: %i[index show] do
    resources :rentals, only: %i[index new create]
  end

  resources :rentals, only: %i[index show] do
    resource :guest, only: %i[new create destroy]
  end

  namespace :admin do
    resources :living_properties, except: :show
    resources :commercial_properties, except: :show
    resources :employees do
      member { patch :enable }
    end
  end

  resource :two_fa, only: %i[new create]

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
