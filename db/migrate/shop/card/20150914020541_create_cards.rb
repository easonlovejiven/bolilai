class CreateCards < ActiveRecord::Migration
  def change
    create_table "shop_cards" do |t|
      t.string   "name"
      t.string   "number"
      t.string   "password"
      t.integer  "value"
      t.integer  "balance"
      t.integer  "price"
      t.datetime "started_at"
      t.datetime "ended_at"
      t.integer  "user_id"
      t.text     "remark"
      t.integer  "editor_id"
      t.boolean  "published",    :default => false, :null => false
      t.boolean  "active",       :default => true,  :null => false
      t.integer  "lock_version", :default => 0,     :null => false
      t.datetime "created_at",                      :null => false
      t.datetime "updated_at",                      :null => false
    end

    add_index "shop_cards", ["active", "published", "user_id", "started_at", "ended_at", "balance"], :name => "by_active_and_published_and_user_id_and_started_at_and_balance"

  end
end
