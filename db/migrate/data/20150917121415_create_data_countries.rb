class CreateDataCountries < ActiveRecord::Migration
  def change
    create_table "data_countries" do |t|
      t.string   "name"
      t.integer  "user_id"
      t.boolean  "active",       :default => true
      t.datetime "destroyed_at"
      t.datetime "created_at",                      :null => false
      t.datetime "updated_at",                      :null => false
      t.integer  "order",        :default => 1
      t.integer  "lock_version", :default => 0
      t.boolean  "published",    :default => false, :null => false
    end

    add_index "data_countries", ["active", "id"], :name => "by_active_and_id"

  end
end
