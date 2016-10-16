class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]
  protect_from_forgery

  # GET /recipes
  # GET /recipes.json
  def index
    @info = Aws.get_records_from_db
    puts "info is: #{@info.inspect}"
  end

  # GET /recipes/1
  # GET /recipes/1.json
  def show
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
        if Aws.save_records_to_db(aws_params)
          msg = { :notice => "Recipe created!" }
          render :json => msg
        else
          msg = { :notice => "Error while save to DynamoDB!" }
          render :json => msg
        end
    # respond_to do |format|
    #   if @recipe.save
    #     format.html { redirect_to @recipe, notice: 'Recipe was successfully created.' }
    #     format.json { render :show, status: :created, location: @recipe }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @recipe.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /recipes/1
  # PATCH/PUT /recipes/1.json
  def update
    respond_to do |format|
      if @recipe.update(recipe_params)
        format.html { redirect_to @recipe, notice: 'Recipe was successfully updated.' }
        format.json { render :show, status: :ok, location: @recipe }
      else
        format.html { render :edit }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recipes/1
  # DELETE /recipes/1.json
  def destroy
    if current_user.recipes.include?(@recipe)
    @recipe.destroy
    respond_to do |format|
      format.html { redirect_to recipes_url, notice: 'Recipe was successfully destroyed.' }
      format.json { head :no_content }
    end
    else
      redirect_to recipes_path
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
