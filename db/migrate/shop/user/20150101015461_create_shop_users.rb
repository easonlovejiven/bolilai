class CreateShopUsers < ActiveRecord::Migration
  def change
    create_table "shop_users", :force => true do |t|
      t.string   "name"
      t.string   "sex"
      t.string   "pic"
      t.date     "birthday"
      t.text     "friend_ids"
      t.datetime "login_at"
      t.datetime "created_at",                                :null => false
      t.datetime "updated_at",                                :null => false
      t.integer  "lock_version",               :default => 0
      t.text     "cart_data"
      t.integer  "level_id",                   :default => 1
      t.integer  "editor_id"
      t.integer  "suggested_level_id"
      t.integer  "percent"
      t.string   "mall_ids"
      t.integer  "trades_amount"
      t.text     "remark"
      t.integer  "trades_price_sum"
      t.integer  "trades_point"
      t.datetime "trades_point_calculated_at"
      t.datetime "level_modified_at"
      t.string   "id_number"
      t.integer  "balance",                    :default => 0, :null => false
      t.string   "crypted_password"
      t.string   "label"
      t.string   "card_number"
      t.integer  "service_editor_id"
      t.integer  "customer_id"
      t.string   "texas_holdem_code"
    end

    create_table "shop_users_updatings", :force => true do |t|
      t.integer  "editor_id"
      t.integer  "user_id"
      t.integer  "level_id"
      t.integer  "percent"
      t.string   "mall_ids"
      t.datetime "created_at",   :null => false
      t.datetime "updated_at",   :null => false
      t.integer  "trades_point"
      t.text     "remark"
    end
  end
end
