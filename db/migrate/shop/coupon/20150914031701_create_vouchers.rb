class CreateVouchers < ActiveRecord::Migration
  def change
    create_table "shop_vouchers" do |t|
      t.integer  "event_id"
      t.integer  "editor_id"
      t.integer  "user_id"
      t.integer  "trade_id"
      t.string   "identifier"
      t.datetime "obtained_at"
      t.datetime "used_at"
      t.text     "remark"
      t.boolean  "active",       :default => true, :null => false
      t.integer  "lock_version", :default => 0,    :null => false
      t.datetime "created_at",                     :null => false
      t.datetime "updated_at",                     :null => false
    end

    add_index "shop_vouchers", ["active", "event_id"], :name => "by_active_and_event_id"
    add_index "shop_vouchers", ["active", "identifier"], :name => "index_shop_vouchers_on_active_and_identifier"
    add_index "shop_vouchers", ["active", "user_id"], :name => "by_active_and_user_id"
    add_index "shop_vouchers", ["identifier"], :name => "index_shop_vouchers_on_identifier"
    add_index "shop_vouchers", ["trade_id"], :name => "index_shop_vouchers_on_trade_id"

  end
end
