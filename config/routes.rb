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
  root "home#redirect_by_role"

  resources :commercial_properties, only: %i[index show]
  resources :living_properties, only: %i[index show]
  resources :garages, only: %i[index show]

  resources :properties, only: [] do
    resources :rentals, only: %i[index new create]
    resource :review, only: %i[new create]
  end

  resources :rentals, only: %i[index show] do
    resource :payment, only: %i[new create]
    resource :guest, only: %i[new create destroy] do
      member do
        get :find_by_dni
        post :add_by_dni
      end
    end
    member do
      post :send_request
      patch :cancel
    end
  end

  resource :profile, only: %i[show edit update] do
    resource :password, only: %i[edit update], controller: "profiles/passwords"
  end

  namespace :admin do
    resources :living_properties, except: :show do
      member { patch :enable }
    end
    resources :commercial_properties, except: :show do
      member { patch :enable }
    end
    resources :garages, except: :show do
      member { patch :enable }
    end
    resources :rentals, only: %i[index show new create] do
      member do
        patch :accept
      end
    end
    resources :employees do
      member { patch :enable }
    end

    resources :reports, only: :index
    namespace :reports do
      get :average_duration
      get :rentals_by_weekday
      get :earnings_by_property_type
    end
  end

  resource :two_fa, only: %i[new create]

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
