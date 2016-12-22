class CreateCoreLogins < ActiveRecord::Migration
  def self.up
    create_table :core_logins do |t|
			t.integer :user_id
			t.date :login_on
			t.string :ip_address, :limit => 20
    end
		add_index :core_logins, [ :user_id, :login_on ]
  end

  def self.down
    drop_table :core_logins
  end
end
