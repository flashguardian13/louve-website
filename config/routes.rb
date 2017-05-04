Rails.application.routes.draw do
  root 'static_pages#home'

  get '/about',         to: 'static_pages#about'
  get '/publications',  to: 'static_pages#publications'
  get '/blogs',         to: 'static_pages#blogs'
  get '/links',         to: 'static_pages#links'
  get '/contact',       to: 'static_pages#contact'

  get  '/login',   to: 'sessions#new'
  post '/login',   to: 'sessions#create'
  get  '/logout',  to: 'sessions#destroy'

  resources :users
  resources :blog_posts
end
