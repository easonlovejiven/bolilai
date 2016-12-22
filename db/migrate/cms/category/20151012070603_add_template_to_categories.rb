class AddTemplateToCategories < ActiveRecord::Migration
  def change
    add_column :cms_categories, :template_type,:string,:default => 'default'
  end
end
