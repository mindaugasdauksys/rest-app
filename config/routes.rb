Rails.application.routes.draw do
  resources :accounts do
    member do
      patch :convert
      get :reselect_currency
    end
  end
  resources :payments do
    collection do
      patch :carry
      get :transfer
    end
  end
  resources :users, only: :create do
    collection do
      post :confirm
      post :login
    end
  end
  resources :branches, only: %i[index show]
  get '/400', to: 'application#render_400'
  get '*unmatched_route', to: 'application#render_not_found'
  post '*unmatched_route', to: 'application#render_not_found'
  patch '*unmatched_route', to: 'application#render_not_found'
  delete '*unmatched_route', to: 'application#render_not_found'
end
