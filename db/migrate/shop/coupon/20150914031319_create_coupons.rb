class CreateCoupons < ActiveRecord::Migration
  def change
    create_table "shop_coupons" do |t|
      t.integer  "editor_id"
      t.string   "code"
      t.string   "name"
      t.text     "description"
      t.datetime "started_at"
      t.datetime "ended_at"
      t.integer  "limitation"
      t.string   "function"
      t.integer  "point"
      t.boolean  "published",    :default => false, :null => false
      t.boolean  "active",       :default => true,  :null => false
      t.integer  "lock_version", :default => 0,     :null => false
      t.datetime "created_at",                      :null => false
      t.datetime "updated_at",                      :null => false
      t.integer  "event_id"
      t.string   "event_ids"
    end

    add_index "shop_coupons", ["active", "published", "code"], :name => "by_active_and_published_and_code"

  end
end
