Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  api_version(:module => "V1", :header => {:name => "Accept", :value => "application/no-q.com; version=1"}) do
    resources :users, only: [:index, :create]
    resources :sessions, only: :create
    resources :stores do
      resources :slots, only: [:index, :create]
    end
  end
end
