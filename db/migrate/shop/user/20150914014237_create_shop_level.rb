class CreateShopLevel < ActiveRecord::Migration
  def change
    create_table "shop_levels" do |t|
      t.integer  "editor_id"
      t.string   "name"
      t.text     "description"
      t.string   "icon"
      t.integer  "limitation"
      t.integer  "percent"
      t.string   "mall_ids"
      t.boolean  "active",       :default => true, :null => false
      t.integer  "lock_version", :default => 0,    :null => false
      t.datetime "created_at",                     :null => false
      t.datetime "updated_at",                     :null => false
      t.integer  "reservation"
    end
  end
end
