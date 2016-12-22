class CreateCmsPages < ActiveRecord::Migration
  def change
    create_table "cms_pages" do |t|
      t.integer :editor_id
      t.string :name, :default => ""
      t.string :template_type, :default => 'full_page'
      t.string :url
      t.string :background
      t.integer :position
      t.text :body
      t.boolean "active", :default => true, :null => false
      t.integer "lock_version", :default => 0, :null => false
      t.timestamps null: false
    end

    add_index "cms_pages", ["active", 'url']
  end
end
