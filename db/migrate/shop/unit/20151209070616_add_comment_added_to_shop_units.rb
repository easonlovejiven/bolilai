class AddCommentAddedToShopUnits < ActiveRecord::Migration
  def change
    add_column :shop_units, "comment_added", :boolean, :default => false, :null => false
  end
end
