Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :accounts, only: [:index, :create, :show, :update, :destroy]
  resources :payments, only: [:index, :show, :create]
  resources :branches, only: [:index, :show]
  patch 'accounts/currency/:id', to: 'accounts#convert'
  get '*unmatched_route', to: 'application#render_404'
  post '*unmatched_route', to: 'application#render_404'
  patch '*unmatched_route', to: 'application#render_404'

end
