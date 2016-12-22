class Core::SettingUpdating < ActiveRecord::Base # :nodoc: all
	self.table_name = :core_settings_updatings

	belongs_to :setting, :class_name => "Core::Setting"
end
