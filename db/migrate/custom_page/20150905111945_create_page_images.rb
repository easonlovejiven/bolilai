class CreatePageImages < ActiveRecord::Migration
  def change
    create_table "custom_page_page_images", :force => true do |t|
      t.integer  "page_id"
      t.string   "pic"
      t.string   "pic_file_name"
      t.integer  "pic_file_size"
      t.string   "pic_content_type"
      t.datetime "pic_updated_at"
      t.integer  "pic_image_width"
      t.integer  "pic_image_height"
      t.boolean  "active",           :default => true, :null => false
      t.integer  "lock_version",     :default => 0,    :null => false
      t.datetime "created_at",                         :null => false
      t.datetime "updated_at",                         :null => false
    end

    add_index "custom_page_page_images", ["active", "page_id"], :name => "index_custom_page_pages_images_on_active_and_page_id"

  end
end
