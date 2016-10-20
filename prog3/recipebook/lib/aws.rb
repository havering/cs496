module Aws
  require 'time'
  #a init method to be used for initialisation when the rails application start
  def self.init
    @@dynamo_db = false
    if AWS_SETTINGS["aws_dynamo"]
      @@dynamo_db = Aws::DynamoDB::Client.new(AWS_SETTINGS["aws_dynamo"])
    end
  end

  #the method that save in aws database
  def self.save_records_to_db(params)
    return if !@@dynamo_db

    fields = {
      'recipe_id' => get_number_of_records, #primary partition key based on number of items already in db
    }
    fields.merge!(params[:custom_fields]) if params[:custom_fields]
    puts "fields are #{fields.inspect}"
    # @@dynamo_table.items.create(fields)
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

  def self.get_records_from_db
    all_tables = @@dynamo_db.list_tables
    my_table = all_tables.table_names.first
    response = @@dynamo_db.scan(table_name: my_table)
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

  def self.delete_item(datetime, member_id)
    all_tables = @@dynamo_db.list_tables
    my_table = all_tables.table_names.first

    params = {
      table_name: my_table,
      key: {
        'member_id' => member_id,
        'datetime' => datetime
      }
    }

    response = @@dynamo_db.delete_item(params)
  end

  def self.list_item(recipe_id)
    all_tables = @@dynamo_db.list_tables
    my_table = all_tables.table_names.first

    response = @@dynamo_db.get_item({
                                      table_name: my_table,
                                      key: {
                                        'recipe_id' => recipe_id.to_i,
                                      }
                                    })
    response.item
  end

  def self.update_item(params)
    all_tables = @@dynamo_db.list_tables
    my_table = all_tables.table_names.first
    puts "params are #{params.inspect}"
    puts "name? #{params[:custom_fields]}"
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
end