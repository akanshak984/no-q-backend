Rails.application.routes.draw do
  api_version(:module => "V1", :header => {:name => "Accept", :value => "application/no-q.com; version=1"}) do
    resources :users
  end  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
