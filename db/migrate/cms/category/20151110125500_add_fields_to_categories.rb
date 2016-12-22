class AddFieldsToCategories < ActiveRecord::Migration
  def change
    add_column :cms_categories, :is_page, :boolean, default: false
    add_column :cms_categories, :page_tmpl, :string, :default => 'full_page'
    add_column :cms_categories, :body, :text
  end
end
