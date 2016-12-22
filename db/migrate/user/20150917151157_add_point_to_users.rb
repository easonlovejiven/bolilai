class AddPointToUsers < ActiveRecord::Migration
  def change
    add_column :users,:point,:integer,defualt: 0
    add_column :users,:shop_point,:integer,defualt: 0
  end
end
