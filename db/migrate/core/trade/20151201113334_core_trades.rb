class CoreTrades < ActiveRecord::Migration
  create_table "core_trades" do |t|
    t.integer "app_id"
    t.string "name", :limit => 40
    t.text "description"
    t.string "icon"
    t.integer "point"
    t.integer "quota"
    t.integer "limit"
    t.string "period", :limit => 20
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "core_trades", ["created_at"], :name => "index_core_trades_on_created_at"
  add_index "core_trades", ["id"], :name => "index_core_trades_on_id"
  add_index "core_trades", ["updated_at"], :name => "index_core_trades_on_updated_at"
end
