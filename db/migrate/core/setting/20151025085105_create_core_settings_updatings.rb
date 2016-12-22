class CreateCoreSettingsUpdatings < ActiveRecord::Migration
  def change
    create_table "core_settings_updatings" do |t|
      t.integer "setting_id"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end

    add_index "core_settings_updatings", ["created_at"], :name => "index_core_settings_updatings_on_created_at"
    add_index "core_settings_updatings", ["setting_id"], :name => "index_core_settings_updatings_on_setting_id"
    add_index "core_settings_updatings", ["updated_at"], :name => "index_core_settings_updatings_on_updated_at"
  end
end
