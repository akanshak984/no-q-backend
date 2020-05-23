Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  api_version(:module => "V1", :header => {:name => "Accept", :value => "application/no-q.com; version=1"}) do
    resources :users, only: [:index, :create]
    resources :sessions, only: :create
    resources :stores, only: :create
    resources :slots, only: [:index] do
      collection do
        post :mark
      end
    end
    resources :categories, only: :index
  end
end
