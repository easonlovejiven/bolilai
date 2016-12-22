class CreateCmsCategories < ActiveRecord::Migration
  def change
    create_table "cms_categories" do |t|
      t.string   "name"
      t.text     "description"
      t.string   "type"
      t.integer  "parent_id"
      t.integer  "pages_count"
      t.string   "url"
      t.integer  "lft"
      t.integer  "rgt"
      t.integer  "depth"
      t.boolean  "published"
      t.text  "side_content"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
