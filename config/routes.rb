Rails.application.routes.draw do
  resources :loans, defaults: {format: :json}
  resources :payments, only: [:index, :show, :create]
end
