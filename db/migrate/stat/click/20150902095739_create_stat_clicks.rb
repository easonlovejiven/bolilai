class CreateStatClicks < ActiveRecord::Migration
	def change
		create_table :stat_clicks do |t|
	    	t.integer  "link_id"
			t.integer  "user_id"
			t.string   "referrer"
			t.string   "ip"
			t.datetime "created_at"
			t.datetime "updated_at"
		    t.string   "url"
		    t.string   "agent"
		    t.string   "path"
		    t.integer  "lock_version", :default => 0
		    t.string   "session_key"
			t.timestamps null: false
		end

		add_index "stat_clicks", ["link_id"], :name => "index_stat_clicks_on_link_id"
	end
end
