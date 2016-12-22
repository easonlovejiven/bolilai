class AddFieldsToUnits < ActiveRecord::Migration
  def change
    add_column :shop_units, "core_point_added", :boolean, :default => false, :null => false
    add_column :shop_units,"core_point_subtracted", :boolean, :default => false, :null => false
    add_column :shop_units,"shop_point_added", :boolean, :default => false, :null => false
    add_column :shop_units,"shop_point_subtracted", :boolean, :default => false, :null => false
  end
end
