Rails.application.routes.draw do
  resources :accounts
  resources :payments
  resources :branches, only: [:index, :show]
  patch 'accounts/currency/:id', to: 'accounts#convert'
  get '*unmatched_route', to: 'application#render_404'
  post '*unmatched_route', to: 'application#render_404'
  patch '*unmatched_route', to: 'application#render_404'
end
