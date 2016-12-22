class CreateCommentImages < ActiveRecord::Migration
  def change
    create_table :comment_images do |t|
      t.integer "user_id"
      t.integer "comment_id"
      t.string "pic"
      t.integer "file_size"
      t.boolean "active", :default => true
      t.integer "lock_version", :default => 0
      t.datetime "destroyed_at"
      t.timestamps null: false
    end
    add_index "comment_images", ["active", "comment_id"], :name => "by_active_and_comment_id"
  end
end
