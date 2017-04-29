Rails.application.routes.draw do
  

  # Root is the unauthenticated path
  root 'sessions#unauth'
  # Sessions URL
  get 'sessions/unauth', as: :login
  post 'sessions/login', as: :signin
  delete 'sessions/logout', as: :logout
  get 'admin/scrape', to: 'articles#scrape', as: 'scrape' 
  get 'articles/interest', to: 'articles#interest', as: 'interest'
  get 'admin/email', to: 'subscriptions#send_email', as: 'send_email'
  put 'subscription/:id(.:format)/:is_subscriber(.:format)', to: 'users#subscription', as:'subscription'
  resources :users
  resources :articles
end
