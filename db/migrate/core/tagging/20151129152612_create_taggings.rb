class CreateTaggings < ActiveRecord::Migration
  create_table "taggings", force: :cascade do |t|
    t.integer "tag_id", limit: 4
    t.integer "taggable_id", limit: 4
    t.string "taggable_type", limit: 255
    t.integer "tagger_id", limit: 4
    t.string "tagger_type", limit: 255
    t.string "context", limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree
end
