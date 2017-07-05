Rails.application.routes.draw do
  root 'static_pages#home'

  get '/about',         to: 'static_pages#about'
  get '/publications',  to: 'publications#index'
  get '/blogs',         to: 'blog_posts#index'
  get '/links',         to: 'external_links#index'
  get '/contact',       to: 'static_pages#contact'

  get    '/edit_home_content',    to: 'static_pages#edit_home_content'
  patch  '/update_home_content',  to: 'static_pages#update_home_content'
  delete '/destroy_home_content', to: 'static_pages#destroy_home_content'

  get  '/login',   to: 'sessions#new'
  post '/login',   to: 'sessions#create'
  get  '/logout',  to: 'sessions#destroy'

  resources :users
  resources :blog_posts
  resources :external_links
  resources :publications do
    resources :retailers
    resources :reviews
  end
end
