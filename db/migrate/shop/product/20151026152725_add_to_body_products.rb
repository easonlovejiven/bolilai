class AddToBodyProducts < ActiveRecord::Migration
  def change
    add_column :shop_products,:body,:text
  end
end
