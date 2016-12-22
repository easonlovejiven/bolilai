class CreateShopEvents < ActiveRecord::Migration
  def change
    create_table "shop_events", :force => true do |t|
      t.integer  "editor_id"
      t.string   "name"
      t.text     "description"
      t.integer  "amount"
      t.integer  "limitation"
      t.datetime "started_at"
      t.datetime "ended_at"
      t.boolean  "active",       :default => true,  :null => false
      t.integer  "lock_version", :default => 0,     :null => false
      t.datetime "created_at",                      :null => false
      t.datetime "updated_at",                      :null => false
      t.integer  "price"
      t.boolean  "published",    :default => false, :null => false
      t.string   "genre"
    end
  end
end
