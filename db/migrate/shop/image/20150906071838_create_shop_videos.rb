class CreateShopVideos < ActiveRecord::Migration
  def change
    create_table "shop_videos", :force => true do |t|
      t.integer "editor_id"
      t.integer "product_id"
      t.string "pic"
      t.text "description"
      t.boolean "active", :default => true, :null => false
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
      t.string "mp4"
      t.string "flv"
      t.string "swf"
      t.boolean "has_audio"
      t.integer "lock_version", :default => 0
      t.string "hd"
    end

    add_index "shop_videos", ["active", "product_id"], :name => "by_active_and_product_id"
  end
end
