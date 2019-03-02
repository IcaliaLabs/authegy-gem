Rails.application.routes.draw do
  root to: 'user_groups#index'

  resources :group_posts
  resources :user_groups

  devise_for :users,
             path: '/',
             path_names: { sign_in: 'sign-in', sign_out: 'sign-out' }

  # For details on the DSL available within this file,
  # see http://guides.rubyonrails.org/routing.html
end
