class AddListPicToProducts < ActiveRecord::Migration
  def change
    add_column :shop_products,:list_pic,:string
  end
end
