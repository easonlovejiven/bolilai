class CreateShopImages < ActiveRecord::Migration
  def change
    create_table "shop_images" do |t|
      t.integer "user_id"
      t.integer "product_id"
      t.string "large"
      t.string "medium"
      t.string "small"
      t.boolean "active", :default => true
      t.datetime "destroyed_at"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
      t.integer "lock_version", :default => 0
      t.text "description"
      t.string "full"
      t.integer "sequence"
    end

    add_index "shop_images", ["active", "product_id"], :name => "by_active_and_product_id"
  end
end
