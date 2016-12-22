class CreateTags < ActiveRecord::Migration

  create_table "tags", force: :cascade do |t|
    t.string "name", limit: 255
    t.integer "taggings_count", limit: 4, default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree
end
