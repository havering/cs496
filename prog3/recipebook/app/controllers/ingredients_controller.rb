class IngredientsController < ApplicationController
  protect_from_forgery

    # GET /ingredients
    # GET /ingredients.json
    def index
      info = Aws.get_ingredients_from_db
      render :json => info
    end

    # GET /ingredients/1
    # GET /ingredients/1.json
    def show
      response = Aws.list_ingredient(params[:id])
      render :json => response
    end

    # GET /ingredients/new
    def new

    end

    # GET /ingredients/1/edit
    def edit

    end

    # POST /ingredients
    # POST /ingredients.json
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
      if Aws.save_ingredient_to_db(aws_params)
        msg = {:notice => "Ingredient created!"}
        render :json => msg
      else
        msg = {:notice => "Error while save to DynamoDB!"}
        render :json => msg
      end
    end

    # PATCH/PUT /ingredients/1
    # PATCH/PUT /ingredients/1.json
    def update
      iid = params['id']
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
      if Aws.update_ingredient(aws_params)
        msg = {:notice => "Ingredient updated!"}
        render :json => msg
      else
        msg = {:notice => "Error while saving ingredient to DynamoDB!"}
        render :json => msg
      end
    end

    # DELETE /ingredients/1
    # DELETE /ingredients/1.json
    def destroy
      iid = params['id']
      if Aws.delete_ingredient(rid, iid)
        msg = {:notice => "Ingredient deleted!"}
        render :json => msg
      else
        msg = {:notice => "Error while deleting from DynamoDB!"}
        render :json => msg
      end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_ingredient
      @ingredient = Ingredient.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ingredient_params
      params.require(:ingredient)
    end
  end
