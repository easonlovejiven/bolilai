class AddPublishedToPages < ActiveRecord::Migration
  def change
    add_column :cms_pages, :published, :boolean, default: false
  end
end
