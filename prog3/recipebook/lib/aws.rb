module Aws
  require 'time'
  #a init method to be used for initialisation when the rails application start
  def self.init
    @@dynamo_db = false
    if AWS_SETTINGS["aws_dynamo"]
      @@dynamo_db = Aws::DynamoDB::Client.new(AWS_SETTINGS["aws_dynamo"])
    end
  end

  ############################################################
  #                                                          #
  #                   Recipe functions                       #
  #                                                          #
  ############################################################

  #the method that save in aws database
  def self.save_recipe_to_db(params)
    return if !@@dynamo_db

    fields = {
      'recipe_id' => get_new_id.to_i + 1, #primary partition key based on number of items already in db
    }
    fields.merge!(params[:custom_fields]) if params[:custom_fields]
    puts "fields are #{fields.inspect}"

    response = @@dynamo_db.put_item({
                                      table_name: "recipes", # required
                                      item: {# required
                                             'recipe_id' => fields['recipe_id'],
                                             'name' => fields['name'],
                                             'description' => fields['description'],
                                             'instructions' => fields['instructions'],
                                             'cook_time' => fields['cook_time'],
                                             'quantity' => fields['quantity'],
                                             'serving_size' => fields['serving_size']
                                      }})
  end

  def self.get_recipes_from_db
    response = @@dynamo_db.scan(table_name: "recipes")
    items = response.items
    items
  end

  def self.get_number_of_records
    items = get_records_from_db
    items.count
  end

  def self.get_table_info
    return if !@@dynamo_db

    @@dynamo_db.list_tables
  end

  # example of finding highest value in a json response: http://stackoverflow.com/questions/9812624/max-value-for-a-multi-key-hash
  def self.get_new_id
    response = @@dynamo_db.scan(table_name: "recipes")
    max = response.items.map { |res| res["recipe_id"].to_f }.max
    puts "max is #{max}"
    max
  end

  def self.delete_recipe(recipe_id)
    params = {
      table_name: "recipes",
      key: {
        'recipe_id' => recipe_id.to_i,
      }
    }

    response = @@dynamo_db.delete_item(params)
  end

  def self.list_recipe(recipe_id)
    response = @@dynamo_db.get_item({
                                      table_name: "recipes",
                                      key: {
                                        'recipe_id' => recipe_id.to_i,
                                      }
                                    })
    response.item
  end

  def self.update_recipe(params)
    puts "params are #{params.inspect}"
    response = @@dynamo_db.update_item({
                                         table_name: "recipes", # required
                                         key: {
                                           'recipe_id' => params[:custom_fields]['recipe_id'].to_i,
                                         },
                                         attribute_updates: {
                                           "name" => {
                                             value: params[:custom_fields]['name'],
                                             action: "PUT",
                                           },
                                           "description" => {
                                             value: params[:custom_fields]['description'],
                                             action: "PUT",
                                           },
                                           "instructions" => {
                                             value: params[:custom_fields]['instructions'],
                                             action: "PUT",
                                           },
                                           "cook_time" => {
                                             value: params[:custom_fields]['cook_time'].to_i,
                                             action: "PUT",
                                           },
                                           "quantity" => {
                                             value: params[:custom_fields]['quantity'],
                                             action: "PUT",
                                           },
                                           "serving_size" => {
                                             value: params[:custom_fields]['serving_size'].to_i,
                                             action: "PUT",
                                           }
                                         }})

  end

  ############################################################
  #                                                          #
  #                   Ingredient functions                   #
  #                                                          #
  ############################################################

  #the method that save in aws database
  def self.save_ingredient_to_db(rid, ingredients)
    return if !@@dynamo_db

    puts "ingredients is: #{ingredients.inspect}"
    if get_new_ing_id(rid).nil?
      iid = 0
    else
      iid = get_new_ing_id(rid) + 1
    end
    response = @@dynamo_db.put_item({
                                      table_name: "ingredients", # required
                                      item: {# required
                                             'recipe_id' => rid.to_i,
                                             'ingredient_id' => iid.to_i,
                                             'name' => ingredients['name'],
                                             'quantity' => ingredients['quantity'],
                                             'measurement' => ingredients['measurement'],
                                      }})
  end

  def self.get_all_ingredients_from_db
    response = @@dynamo_db.scan(table_name: "ingredients")
    items = response.items
    items
  end

  def self.get_ingredients_from_db(rid)
    response = @@dynamo_db.query({
                                   table_name: "ingredients",
                                   select: "ALL_ATTRIBUTES",
                                   key_conditions: {
                                     "recipe_id" => {
                                       attribute_value_list: [rid.to_i],
                                       comparison_operator: "EQ"
                                     }
                                   }
                                 })

    items = response.items
    puts "get_ing_from_db items: #{items.inspect}"
    items
  end

  def self.get_new_ing_id(rid)
    response = @@dynamo_db.scan(table_name: "ingredients")
    finder = Hash[response.items.map { |h| h.values_at('recipe_id', 'ingredient_id') }]
    max = finder[rid.to_d]
    puts "max is #{max}"
    max
  end

  def self.delete_ingredient(recipe_id, ingredient_id)
    params = {
      table_name: "ingredients",
      key: {
        'recipe_id' => recipe_id.to_i,
        'ingredient_id' => ingredient_id.to_i
      }
    }

    response = @@dynamo_db.delete_item(params)
  end

  def self.list_ingredient(recipe_id, ingredient_id)
    response = @@dynamo_db.get_item({
                                      table_name: "ingredients",
                                      key: {
                                        'recipe_id' => recipe_id.to_i,
                                        'ingredient_id' => ingredient_id.to_i
                                      }
                                    })
    response.item
  end

  def self.update_ingredient(params)
    response = @@dynamo_db.update_item({
                                         table_name: "ingredients", # required
                                         key: {
                                           'recipe_id' => params[:custom_fields]['recipe_id'].to_i, #partition key
                                           'ingredient_id' => params[:custom_fields]['recipe_id'].to_i # sort key
                                         },
                                         attribute_updates: {
                                           "name" => {
                                             value: params[:custom_fields]['name'],
                                             action: "PUT",
                                           },
                                           "description" => {
                                             value: params[:custom_fields]['description'],
                                             action: "PUT",
                                           },
                                           "instructions" => {
                                             value: params[:custom_fields]['instructions'],
                                             action: "PUT",
                                           },
                                           "cook_time" => {
                                             value: params[:custom_fields]['cook_time'].to_i,
                                             action: "PUT",
                                           },
                                           "quantity" => {
                                             value: params[:custom_fields]['quantity'],
                                             action: "PUT",
                                           },
                                           "serving_size" => {
                                             value: params[:custom_fields]['serving_size'].to_i,
                                             action: "PUT",
                                           }
                                         }})

  end
end