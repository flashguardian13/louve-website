Rails.application.routes.draw do
  resources :external_links
  root 'static_pages#home'

  get '/about',         to: 'static_pages#about'
  get '/publications',  to: 'static_pages#publications'
  get '/blogs',         to: 'blog_posts#index'
  get '/links',         to: 'external_links#index'
  get '/contact',       to: 'static_pages#contact'

  get  '/login',   to: 'sessions#new'
  post '/login',   to: 'sessions#create'
  get  '/logout',  to: 'sessions#destroy'

  resources :users
  resources :blog_posts
end
