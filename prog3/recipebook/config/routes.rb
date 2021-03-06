Rails.application.routes.draw do
  get 'users/:id/recipes' => 'users#recipes', as: 'user_recipes'
  get 'recipes/:id/ingredients' => 'recipes#list_ingredients', as: 'list_ingredients'
  post 'recipes/:id/ingredients' => 'recipes#add_ingredients', as: 'add_ingredients'
  put 'recipes/:id/ingredients/:ingredient_id' => 'recipes#update_ingredients', as: 'update_ingredients'
  get 'recipes/ingredients' => 'recipes#all_ingredients', as: 'all_ingredients'
  delete 'recipes/:id/ingredients/:ingredient_id' => 'recipes#delete_ingredient', as: 'delete_ingredient'
  delete 'recipes/:id/ingredients' => 'recipes#delete_all_ingredients', as: 'delete_all'

  resources :recipes
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'recipes#index'
end
