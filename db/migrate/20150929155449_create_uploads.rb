class CreateUploads < ActiveRecord::Migration
  def change
    create_table "uploads", force: true do |t|
      t.integer "attachmentable_id"
      t.string "attachmentable_type"
      t.integer "user_id"
      t.string "file_key"
      t.string "file_name"
      t.integer "file_size"
      t.string "file_type"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "uploads", ["attachmentable_id", "attachmentable_type"], name: "index_uploads_on_attachmentable", using: :btree
    add_index "uploads", ["user_id"], name: "index_uploads_on_user_id", using: :btree
  end
end
