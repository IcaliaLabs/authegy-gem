Rails.application.routes.draw do
  root to: 'user_groups#index'

  resources :group_posts
  resources :user_groups

  authegy_routes

  # For details on the DSL available within this file,
  # see http://guides.rubyonrails.org/routing.html
end
