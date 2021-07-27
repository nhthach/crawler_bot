Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  root 'home#index'
  get 'data_stream', to: 'fetching_data#data_stream', defaults: { format: :json }
  match "*path", to: 'home#index', via: :all
end
