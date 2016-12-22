class AddAdvToShopCategories < ActiveRecord::Migration
  def change
    add_column :shop_categories,"banner_pic",:string
    add_column :shop_categories,"banner_pic_link",:string
  end
end
