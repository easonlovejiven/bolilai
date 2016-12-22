class AddBasicAttributeIdsToShopCategories < ActiveRecord::Migration
  def change
    add_column :shop_categories,"basic_attribute_ids",:string
  end
end
