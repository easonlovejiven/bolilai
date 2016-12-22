class AddFieldsToCategroies < ActiveRecord::Migration
  def change
    add_column :shop_categories,:lft,:integer
    add_column :shop_categories,:rgt,:integer
    add_column :shop_categories,:depth,:integer
    add_column :shop_categories,:position,:integer
  end
end
