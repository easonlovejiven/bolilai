class Core::InfoUpdating < ActiveRecord::Base # :nodoc: all
	self.table_name = :core_infos_updatings

	belongs_to :info, :class_name => "Core::Info"
end
