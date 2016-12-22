class CreateCoreUsers < ActiveRecord::Migration
  def change
    create_table "core_users" do |t|
      t.string "pic"
      t.string "name", :limit => 20
      t.string "sex", :limit => 20
      t.date "birthday"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
      t.string "abbrs"
      t.integer "photo_id"
      t.integer "invite_count"
      t.boolean "active", :default => true, :null => false
    end

    add_index "core_users", ["birthday"], :name => "index_core_users_on_birthday"
    add_index "core_users", ["created_at"], :name => "index_core_users_on_created_at"
    add_index "core_users", ["id"], :name => "index_core_users_on_id"
    add_index "core_users", ["updated_at"], :name => "index_core_users_on_updated_at"

    create_table "core_users_readings" do |t|
      t.integer "user_id"
      t.integer "duration"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end

    add_index "core_users_readings", ["created_at"], :name => "index_core_users_readings_on_created_at"
    add_index "core_users_readings", ["updated_at"], :name => "index_core_users_readings_on_updated_at"
    add_index "core_users_readings", ["user_id"], :name => "index_core_users_readings_on_user_id"

    create_table "core_users_updatings" do |t|
      t.integer "user_id"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end
  end
end
