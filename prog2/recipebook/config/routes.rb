Rails.application.routes.draw do
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  get 'logout' => 'sessions#destroy'
  get 'signup' => 'users#new'
  get 'users/:id/recipes' => 'users#recipes', as: 'user_recipes'

  resources :recipes
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'recipes#index'
end
