class Core::AccountUpdating < ActiveRecord::Base #:nodoc: all
	self.table_name = :core_accounts_updatings

	belongs_to :account, :class_name => "Core::Account"
end
