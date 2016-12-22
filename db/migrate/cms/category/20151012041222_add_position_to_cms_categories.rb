class AddPositionToCmsCategories < ActiveRecord::Migration
  def change
    add_column :cms_categories, :position,:integer,limit: 4
  end
end
