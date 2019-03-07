Rails.application.routes.draw do
  authegy_routes
  root to: 'user_groups#index'

  resources :groups, controller: :user_groups do
    resources :posts, controller: :group_posts
  end

  # For details on the DSL available within this file,
  # see http://guides.rubyonrails.org/routing.html
end
