class CreateShopSynonyms < ActiveRecord::Migration
  def change
    create_table "shop_synonyms", :force => true do |t|
      t.integer  "editor_id"
      t.string   "name"
      t.integer  "brand_id"
      t.integer  "category1_id"
      t.integer  "category2_id"
      t.string   "target"
      t.string   "color"
      t.boolean  "active",       :default => true, :null => false
      t.boolean  "published"
      t.integer  "lock_version", :default => 0,    :null => false
      t.datetime "created_at",                     :null => false
      t.datetime "updated_at",                     :null => false
    end

    add_index "shop_synonyms", ["active", "published", "name"], :name => "by_active_and_published_and_name"

  end
end
