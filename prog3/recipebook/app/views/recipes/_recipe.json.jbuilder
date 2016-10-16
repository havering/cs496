json.extract! recipe, :id, :name, :description, :instructions, :servings, :cook_time, :created_at, :updated_at
json.url recipe_url(recipe, format: :json)