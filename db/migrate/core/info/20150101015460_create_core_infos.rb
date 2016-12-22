class CreateCoreInfos < ActiveRecord::Migration
  def change
    create_table "core_infos", :force => true do |t|
      t.string "im"
      t.string "mobile"
      t.string "phone"
      t.string "website"
      t.text "about"
      t.text "interest"
      t.text "music"
      t.text "movie"
      t.text "tvshow"
      t.text "game"
      t.text "comic"
      t.text "sport"
      t.text "book"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
      t.integer "hometown_id"
      t.integer "location_id"
      t.string "status"
      t.integer "gene_point", :default => 0
      t.datetime "point_updated_at"
      t.boolean "registration_completed"
      t.integer "point", :default => 0
      t.integer "auction_point", :default => 0
    end

    add_index "core_infos", ["created_at"], :name => "index_core_infos_on_created_at"
    add_index "core_infos", ["hometown_id"], :name => "index_core_infos_on_hometown_id"
    add_index "core_infos", ["id"], :name => "index_core_infos_on_id"
    add_index "core_infos", ["location_id"], :name => "index_core_infos_on_location_id"
    add_index "core_infos", ["updated_at"], :name => "index_core_infos_on_updated_at"

    create_table "core_infos_updatings", :force => true do |t|
      t.integer "info_id"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end

    add_index "core_infos_updatings", ["created_at"], :name => "index_core_infos_updatings_on_created_at"
    add_index "core_infos_updatings", ["info_id"], :name => "index_core_infos_updatings_on_info_id"
    add_index "core_infos_updatings", ["updated_at"], :name => "index_core_infos_updatings_on_updated_at"
  end
end
