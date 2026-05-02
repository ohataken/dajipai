Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    resources :cards, only: [ :index, :create, :update ], param: :uuid
    resources :tags, only: [ :index ], param: :slug do
      resources :cards, only: [ :index ], controller: "tags/cards"
    end

    namespace :owner do
      resources :cards, only: [ :create ], param: :uuid do
        resources :card_tags, only: [ :create ], path: "tags"
      end
      resources :tags, only: [ :create ]
    end
  end

  # Defines the root path route ("/")
  # root "posts#index"
end
