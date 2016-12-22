class CreateStatLinks < ActiveRecord::Migration
	def change
	    create_table :stat_links do |t|
	    	t.integer  "editor_id"
		    t.string   "url"
		    t.string   "source"
		    t.string   "identifier"
		    t.integer  "price"
		    t.boolean  "active",       :default => true, :null => false
		    t.datetime "destroyed_at"
		    t.datetime "created_at"
		    t.datetime "updated_at"
		    t.string   "name"
		    t.string   "description"
		    t.integer  "ad_id"
		    t.integer  "lock_version", :default => 0
		    t.timestamps null: false
		end
		add_index "stat_links", ["active", "id"], :name => "by_active_and_id"
	end
end
