class AddPublicProfileToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :public_profile, :boolean, :default => true
  end
end
