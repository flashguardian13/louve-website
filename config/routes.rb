Rails.application.routes.draw do
  get 'static_pages/home'
  get 'static_pages/help'

  root 'home#show'
end
