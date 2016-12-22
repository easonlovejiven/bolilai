class CreateShopSmss < ActiveRecord::Migration
  def change
    create_table "shop_smss" do |t|
      t.integer "editor_id"
      t.integer "trade_id"
      t.integer "costumer_id"
      t.string "phone"
      t.text "content"
      t.text "remark"
      t.boolean "active", :default => true, :null => false
      t.boolean "success", :default => false, :null => false
      t.integer "lock_version", :default => 0, :null => false
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
      t.datetime "send_at"
      t.integer "user_id"
    end

    add_index "shop_smss", ["active", "trade_id"], :name => "index_shop_smss_on_active_and_trade_id"

  end
end
