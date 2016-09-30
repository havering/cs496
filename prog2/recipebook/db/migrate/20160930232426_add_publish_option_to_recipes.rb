class AddPublishOptionToRecipes < ActiveRecord::Migration[5.0]
  def change
    add_column :recipes, :published, :boolean, :default => false
  end
end
