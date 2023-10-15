Rails.application.routes.draw do
  root 'forecasts#show'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get 'forecast', to: 'forecasts#show', as: 'forecast'

  scope 'forecasts' do
    get 'search', to: 'forecasts#search', defaults: { format: :json }
    get 'fetch_forecast', to: 'forecasts#fetch_forecast'
  end


  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
