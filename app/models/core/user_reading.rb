class Core::UserReading < ActiveRecord::Base # :nodoc: all
	self.table_name = :core_users_readings

	belongs_to :user
	belongs_to :user, :class_name => "Core::User"
end
