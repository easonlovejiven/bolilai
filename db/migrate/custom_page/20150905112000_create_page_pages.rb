class CreatePagePages < ActiveRecord::Migration
  def change
    create_table "custom_page_pages_pages", :force => true do |t|
      t.integer  "page_id"
      t.integer  "child_id"
      t.boolean  "active",       :default => true, :null => false
      t.integer  "lock_version", :default => 0,    :null => false
      t.datetime "created_at",                     :null => false
      t.datetime "updated_at",                     :null => false
    end

    add_index "custom_page_pages_pages", ["active", "page_id", "child_id"], :name => "by_active_and_page_id_and_child_id"

  end
end
