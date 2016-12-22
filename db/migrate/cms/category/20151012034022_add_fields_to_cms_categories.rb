class AddFieldsToCmsCategories < ActiveRecord::Migration
  def change
    add_column :cms_categories,:active, :boolean,:default => true, :null => false
    add_column :cms_categories, :lock_version,:integer, :default => 0, :null => false
  end
end
