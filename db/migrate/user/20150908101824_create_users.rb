class CreateUsers < ActiveRecord::Migration
  def change
    create_table "users" do |t|
      t.string "nickname", limit: 255
      t.string "name"
      t.string "pic"
      t.string "sex"
      t.string "qq", limit: 255
      t.string "phone", limit: 255
      t.string "name", limit: 255
      t.text "description", limit: 65535
      t.string "email", limit: 255, default: "", null: false
      t.string "encrypted_password", limit: 255, default: "", null: false
      t.string "reset_password_token", limit: 255
      t.datetime "reset_password_sent_at"
      t.datetime "remember_created_at"
      t.integer "sign_in_count", limit: 4, default: 0, null: false
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.string "current_sign_in_ip", limit: 255
      t.string "last_sign_in_ip", limit: 255
      t.string "confirmation_token", limit: 255
      t.datetime "confirmed_at"
      t.datetime "confirmation_sent_at"
      t.string "unconfirmed_email", limit: 255
      t.string "role", limit: 255, default: "normal", null: false
      t.date "birthday"
      t.text "friend_ids"
      t.datetime "login_at"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
      t.integer "lock_version", :default => 0
      t.text "cart_data"
      t.integer "level_id", :default => 1
      t.integer "editor_id"
      t.integer "suggested_level_id"
      t.integer "percent"
      t.string "mall_ids"
      t.integer "trades_amount"
      t.text "remark"
      t.integer "trades_price_sum"
      t.integer "trades_point"
      t.datetime "trades_point_calculated_at"
      t.datetime "level_modified_at"
      t.string "id_number"
      t.integer "balance", :default => 0, :null => false
      t.string "label"
      t.string "card_number"
      t.integer "service_editor_id"
      t.integer "customer_id"
      t.string "texas_holdem_code"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

    add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
    add_index "users", ["nickname"], name: "index_users_on_nickname", unique: true, using: :btree
    add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", using: :btree
  end
end
