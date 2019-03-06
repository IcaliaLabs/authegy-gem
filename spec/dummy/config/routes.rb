Rails.application.routes.draw do
  authegy_routes
  root to: 'user_groups#index'

  resources :group_posts
  resources :user_groups

  # For details on the DSL available within this file,
  # see http://guides.rubyonrails.org/routing.html
end
