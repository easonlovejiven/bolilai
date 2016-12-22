class AddFieldsToCmsPages < ActiveRecord::Migration
  def change
    add_column :cms_pages,:category_id,:integer
  end
end
