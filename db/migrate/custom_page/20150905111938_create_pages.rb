class CreatePages < ActiveRecord::Migration
  def change
    create_table "custom_page_pages" do |t|
      t.string   "name"
      t.string   "position"
      t.string   "engine"
      t.text     "content"
      t.integer  "editor_id"
      t.boolean  "published",             :default => false, :null => false
      t.boolean  "active",                :default => true,  :null => false
      t.integer  "lock_version",          :default => 0,     :null => false
      t.datetime "created_at",                               :null => false
      t.datetime "updated_at",                               :null => false
      t.string   "title"
      t.string   "series"
      t.string   "snapshot"
      t.string   "snapshot_file_name"
      t.integer  "snapshot_file_size"
      t.string   "snapshot_content_type"
      t.datetime "snapshot_updated_at"
      t.integer  "snapshot_image_width"
      t.integer  "snapshot_image_height"
      t.string   "keywords"
      t.string   "description"
    end

    add_index "custom_page_pages", ["active", "id"], :name => "by_active_and_id"
    add_index "custom_page_pages", ["active", "published", "position", "id"], :name => "by_active_and_published_and_position_and_id"

  end
end
