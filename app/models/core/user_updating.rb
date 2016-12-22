class Core::UserUpdating < ActiveRecord::Base # :nodoc: all
	self.table_name = :core_users_updatings

	belongs_to :user, :class_name => "Core::User"
end
