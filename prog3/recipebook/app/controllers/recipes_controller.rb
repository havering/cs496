class RecipesController < ApplicationController
  protect_from_forgery

  # GET /recipes
  # GET /recipes.json
  def index
    info = Aws.get_recipes_from_db
    render :json => info
  end

  # GET /recipes/1
  # GET /recipes/1.json
  def show
    response = Aws.list_recipe(params[:id])
    render :json => response
  end

  # GET /recipes/new
  def new

  end

  # GET /recipes/1/edit
  def edit

  end

  # POST /recipes
  # POST /recipes.json
  def create
    name = params['name']
    description = params['description']
    instructions = params['instructions']
    cook_time = params['cook_time']
    quantity = params['quantity']
    serving_size = params['serving_size']
    aws_params = Hash.new
    aws_params[:custom_fields] = {
      'name' => name,
      'description' => description,
      'instructions' => instructions,
      'cook_time' => cook_time,
      'quantity' => quantity,
      'serving_size' => serving_size
    }
    if Aws.save_recipe_to_db(aws_params)
      msg = {:notice => "Recipe created!"}
      render :json => msg
    else
      msg = {:notice => "Error while save to DynamoDB!"}
      render :json => msg
    end
  end

  # PATCH/PUT /recipes/1
  # PATCH/PUT /recipes/1.json
  def update
    rid = params['id']
    name = params['name']
    description = params['description']
    instructions = params['instructions']
    cook_time = params['cook_time']
    quantity = params['quantity']
    serving_size = params['serving_size']
    aws_params = Hash.new
    aws_params[:custom_fields] = {
      'recipe_id' => rid,
      'name' => name,
      'description' => description,
      'instructions' => instructions,
      'cook_time' => cook_time,
      'quantity' => quantity,
      'serving_size' => serving_size
    }
    if Aws.update_recipe(aws_params)
      msg = {:notice => "Recipe updated!"}
      render :json => msg
    else
      msg = {:notice => "Error while save to DynamoDB!"}
      render :json => msg
    end
  end

  # DELETE /recipes/1
  # DELETE /recipes/1.json
  def destroy
    rid = params['id']
    if Aws.delete_recipe(rid) && Aws.delete_associated_ingredients(rid)
      msg = {:notice => "Recipe deleted!"}
      render :json => msg
    else
      msg = {:notice => "Error while deleting from DynamoDB!"}
      render :json => msg
    end
  end

  # GET /recipes/1/ingredients
  # GET /recipes/1/ingredients.json
  def list_ingredients
    rid = params[:id]
    items = Aws.get_ingredients_from_db(rid)
    render :json => items
  end

  # GET /recipes/ingredients
  def all_ingredients
    items = Aws.get_all_ingredients_from_db
    render :json => items
  end

  # POST recipes/1/ingredients
  # POST /recipes/1/ingredients.json
  def add_ingredients
    rid = params['id']
    name = params['name']
    quant = params['quantity']
    meas = params['measurement']

    ingredients = {
      'name' => name,
      'quantity' => quant,
      'measurement' => meas,
    }

    if Aws.save_ingredient_to_db(rid, ingredients)
      msg = {:notice => "Ingredient created!"}
      render :json => msg
    else
      msg = {:notice => "Error while creating ingredient!"}
      render :json => msg
    end
  end

  # PUT/PATCH recipes/1/ingredients/1
  def update_ingredients
    rid = params['id']
    iid = params['ingredient_id']
    name = params['name']
    quant = params['quantity']
    meas = params['measurement']

    aws_params = Hash.new
    aws_params[:custom_fields] = {
      'recipe_id' => rid,
      'ingredient_id' => iid,
      'name' => name,
      'quantity' => quant,
      'measurement' => meas,
    }

    if Aws.update_ingredient(aws_params)
      msg = {:notice => "Ingredient updated!"}
      render :json => msg
    else
      msg = {:notice => "Error while updating ingredient!"}
      render :json => msg
    end
  end

  # DELETE /recipes/1/
  # DELETE /recipes/1.json
  def delete_all_ingredients
    rid = params['id']

    if Aws.delete_all_ingredients(rid)
      msg = {:notice => "All ingredients deleted!"}
      render :json => msg
    else
      msg = {:notice => "Error while deleting all ingredients!"}
      render :json => msg
    end
  end

  # DELETE /recipes/1/ingredients/1
  def delete_ingredient
    rid = params['id']
    iid = params['ingredient_id']

    if Aws.delete_ingredient(rid, iid)
      msg = {:notice => "Ingredient deleted!"}
      render :json => msg
    else
      msg = {:notice => "Error while deleting ingredient!"}
      render :json => msg
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def recipe_params
    params.require(:recipe).permit(:name, :description, :instructions, :servings, :cook_time, :published)
  end
end
