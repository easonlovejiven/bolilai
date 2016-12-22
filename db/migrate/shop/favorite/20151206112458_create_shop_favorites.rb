class CreateShopFavorites < ActiveRecord::Migration
  def change
    create_table "shop_favorites" do |t|
      t.integer  "user_id"
      t.integer  "product_id"
      t.boolean  "active",       :default => true, :null => false
      t.datetime "created_at",                     :null => false
      t.datetime "updated_at",                     :null => false
      t.integer  "lock_version", :default => 0
    end

    add_index "shop_favorites", ["user_id", "product_id"], :name => "by_user_id_and_product_id"

  end
end
