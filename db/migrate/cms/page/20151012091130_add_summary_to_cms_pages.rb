class AddSummaryToCmsPages < ActiveRecord::Migration
  def change
    add_column :cms_pages,:pic_url,:string
    add_column :cms_pages,:summary,:text
    add_column :cms_pages,:simplify,:text
    add_column :cms_pages,:upload_keys,:text
  end
end
