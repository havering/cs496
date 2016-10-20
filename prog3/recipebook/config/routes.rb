Rails.application.routes.draw do
  get 'users/:id/recipes' => 'users#recipes', as: 'user_recipes'
  get 'recipes/:id/ingredients' => 'recipes#list_ingredients', as: 'list_ingredients'
  post 'recipes/:id/ingredients' => 'recipes#add_ingredients', as: 'add_ingredients'
  put 'recipes/:id/ingredients' => 'recipes#add_ingredients', as: 'update_ingredients'

  resources :recipes
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'recipes#index'
end
