class CreateCoreAccounts < ActiveRecord::Migration
  def change
    create_table "core_accounts" do |t|
      t.string   "email",                            :limit => 100
      t.string   "crypted_password",                 :limit => 40
      t.string   "salt",                             :limit => 40
      t.string   "remember_token",                   :limit => 40
      t.datetime "remember_token_expires_at"
      t.string   "activation_code",                  :limit => 40
      t.datetime "activated_at"
      t.datetime "created_at",                                                        :null => false
      t.datetime "updated_at",                                                        :null => false
      t.boolean  "active",                                          :default => true
      t.datetime "destroyed_at"
      t.integer  "referrer_id"
      t.string   "source"
      t.string   "information"
      t.integer  "link_id"
      t.string   "phone"
      t.datetime "phone_activated_at"
      t.string   "phone_activation_code"
      t.datetime "phone_activation_code_expired_at"
      t.string   "ip_address"
      t.integer  "click_id"
      t.string   "client"
      t.integer  "shop_id"
      t.integer  "guide_id"
      t.integer  "latest_link_id"
      t.integer  "latest_click_id"
      t.date     "last_login_on"
    end

    add_index "core_accounts", ["active", "activated_at", "id"], :name => "by_active_and_activated_at_and_id"
    add_index "core_accounts", ["email"], :name => "index_core_accounts_on_email", :unique => true
    add_index "core_accounts", ["ip_address", "created_at"], :name => "by_ip_address_and_created_at"
    add_index "core_accounts", ["link_id"], :name => "index_core_accounts_on_link_id"
    add_index "core_accounts", ["phone"], :name => "index_core_accounts_on_phone"
  end
end
